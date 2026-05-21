import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:radiology_and_lab_app/core/constants/app_strings.dart';
import 'package:radiology_and_lab_app/core/services/user_session_service.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_entity.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_enums.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/cubit/appointment_cubit.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/cubit/appointment_state.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/widgets/patint/date_selector.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/widgets/patint/department_selector.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/widgets/patint/test_type_chip.dart';
import 'package:radiology_and_lab_app/shared/widgets/app_snackbar.dart';

/// BookAppointmentScreen
///
/// Government hospital queue-based booking flow:
///   1. Select department
///   2. Select test type
///   3. Select preferred date
///   4. Select referring doctor from dropdown — REQUIRED
///   5. Enter notes — Optional
///   6. Confirm → saved as status=pending (queueNumber assigned LATER by queue_feature)
class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  // ── Form state ─────────────────────────────────────────────────────────────
  String _selectedDepartment = 'Radiology';
  String? _selectedTestType;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  Map<String, String>? _selectedDoctor;
  final _notesController = TextEditingController();
  List<Map<String, String>> _doctors = [];

  // ── Test types per department ──────────────────────────────────────────────
  static const Map<String, List<String>> _testTypes = {
    'Radiology': ['MRI Scan', 'CT Scan', 'X-Ray', 'Ultrasound', 'Mammography'],
    'Laboratory': [
      'Complete Blood Count',
      'Blood Chemistry',
      'Urine Analysis',
      'Pathology',
      'Biopsy',
    ],
  };

  @override
  void initState() {
    super.initState();
    context.read<AppointmentCubit>().getDoctors();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  // ── Book action ────────────────────────────────────────────────────────────
  void _bookAppointment() {
    if (_selectedTestType == null) {
      AppSnackBar.showError(context, 'Please select a test type');
      return;
    }

    if (_selectedDoctor == null) {
      AppSnackBar.showError(context, 'Referring doctor selection is required');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      AppSnackBar.showError(
        context,
        'You must be logged in to book an appointment',
      );
      return;
    }

    // Date set to start of day — no exact time reservation in government queue flow.
    final appointmentDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );

    final notes =
        _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim();

    final appointment = AppointmentEntity(
      id: '',
      patientId: user.uid,
      patientName: UserSessionService.currentUser?.fullName ?? user.displayName ?? 'Patient',
      department: _selectedDepartment,
      testType: _selectedTestType!,
      appointmentDateTime: appointmentDate,
      notes: notes,
      status: AppointmentStatus.pending,
      isNoShow: false,
      doctorId: _selectedDoctor!['id']!,
      doctorName: _selectedDoctor!['name']!,
      createdByType: 'patient_direct',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    context.read<AppointmentCubit>().bookAppointment(appointment);
  }

  // ── UI ─────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: context.canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(AppStrings.dashboardRoute, extra: UserSessionService.currentUser);
                  }
                },
              )
            : null,
        title: const Text(
          'Book Appointment',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<AppointmentCubit, AppointmentState>(
        listener: (context, state) {
          if (state is AppointmentBookedSuccess) {
            AppSnackBar.showSuccess(
              context,
              'Appointment booked — pending doctor approval',
            );
            context.push(
              AppStrings.myAppointmentsRoute,
              extra: {'showBackButton': true},
            );
            
          } else if (state is AppointmentError) {
            AppSnackBar.showError(context, state.message);
          } else if (state is DoctorsLoaded) {
            debugPrint('DOCTORS: ${state.doctors}');
            setState(() {
              _doctors = state.doctors;
            });
          }
        },
        builder: (context, state) {
          final isLoading = state is AppointmentLoading && _doctors.isEmpty;
          final isBooking = state is AppointmentLoading && _doctors.isNotEmpty;

          return Stack(
            children: [
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else
                SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 220,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Department ──────────────────────────────────────────
                      _sectionLabel('Select Department'),
                      const SizedBox(height: 12),
                      DepartmentSelector(
                        selectedDepartment: _selectedDepartment,
                        onDepartmentSelected:
                            (dept) => setState(() {
                              _selectedDepartment = dept;
                              _selectedTestType = null;
                            }),
                      ),

                      const SizedBox(height: 24),

                      // ── Test Type ───────────────────────────────────────────
                      _sectionLabel('Select Test Type'),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 48,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children:
                              _testTypes[_selectedDepartment]!
                                  .map(
                                    (type) => TestTypeChip(
                                      label: type,
                                      isSelected: _selectedTestType == type,
                                      onTap:
                                          () => setState(
                                            () => _selectedTestType = type,
                                          ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Preferred Date ──────────────────────────────────────
                      _sectionLabel('Select Preferred Date'),
                      const SizedBox(height: 12),
                      DateSelector(
                        selectedDate: _selectedDate,
                        onDateSelected:
                            (d) => setState(() => _selectedDate = d),
                      ),

                      const SizedBox(height: 24),

                      // ── Referring Doctor (REQUIRED) ─────────────────────────
                      _sectionLabel('Referring Doctor  (Required)'),
                      const SizedBox(height: 12),
                      _DoctorDropdown(
                        doctors: _doctors,
                        selectedDoctor: _selectedDoctor,
                        onChanged:
                            (doctor) =>
                                setState(() => _selectedDoctor = doctor),
                      ),

                      const SizedBox(height: 8),
                      Text(
                        'Tests cannot be requested without a doctor referral.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Notes (Optional) ────────────────────────────────────
                      _sectionLabel('Notes  (Optional)'),
                      const SizedBox(height: 12),
                      _NotesField(controller: _notesController),
                    ],
                  ),
                ),

              // ── Bottom Summary + Confirm ─────────────────────────────────
              if (_doctors.isNotEmpty)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _BottomSummaryBar(
                    department: _selectedDepartment,
                    testType: _selectedTestType,
                    date: _selectedDate,
                    doctorName: _selectedDoctor?['name'] ?? 'Not Selected',
                    isLoading: isBooking,
                    onConfirm: _bookAppointment,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Color(0xFF1F2937),
    ),
  );
}

// ── Doctor Dropdown ───────────────────────────────────────────────────────────
class _DoctorDropdown extends StatelessWidget {
  final List<Map<String, String>> doctors;
  final Map<String, String>? selectedDoctor;
  final ValueChanged<Map<String, String>?> onChanged;

  const _DoctorDropdown({
    required this.doctors,
    required this.selectedDoctor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Map<String, String>>(
      value: selectedDoctor,
      items:
          doctors.map((doctor) {
            return DropdownMenuItem<Map<String, String>>(
              value: doctor,
              child: Text(doctor['name']!),
            );
          }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Select Referring Doctor',
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon: Icon(Icons.person_outline, color: Colors.grey.shade500),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0D9488)),
        ),
      ),
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down),
    );
  }
}

// ── Notes Field ───────────────────────────────────────────────────────────────
class _NotesField extends StatelessWidget {
  final TextEditingController controller;

  const _NotesField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 3,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        hintText: 'Any symptoms or additional notes...',
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0D9488)),
        ),
      ),
    );
  }
}

// ── Bottom Summary Bar ────────────────────────────────────────────────────────
class _BottomSummaryBar extends StatelessWidget {
  final String department;
  final String? testType;
  final DateTime date;
  final String doctorName;
  final bool isLoading;
  final VoidCallback onConfirm;

  const _BottomSummaryBar({
    required this.department,
    required this.testType,
    required this.date,
    required this.doctorName,
    required this.isLoading,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final formattedDate = '${months[date.month - 1]} ${date.day}, ${date.year}';

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'APPOINTMENT SUMMARY',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 15,
                  color: Color(0xFF0D9488),
                ),
                const SizedBox(width: 8),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.medical_services_outlined,
                  size: 15,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  testType != null ? '$department — $testType' : department,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 15, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Dr. $doctorName',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.info_outline, size: 14, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'Waiting for doctor approval',
                  style: TextStyle(color: Colors.orange.shade700, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isLoading ? null : onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF111827),
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child:
                    isLoading
                        ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                        : const Text(
                          'Confirm Appointment',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
