import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_entity.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_enums.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/cubit/appointment_cubit.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/cubit/appointment_state.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/widgets/patint/appointment_card.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/widgets/patint/empty_appointments_widget.dart';
import 'package:radiology_and_lab_app/shared/widgets/app_snackbar.dart';

class MyAppointmentsScreen extends StatefulWidget {
  final bool showBackButton;
  const MyAppointmentsScreen({super.key, this.showBackButton = false});

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = [
    'All',
    'Pending',
    'Confirmed',
    'Completed',
    'Cancelled',
  ];

  @override
  void initState() {
    super.initState();
    // Fetch appointments for the current user
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<AppointmentCubit>().getPatientAppointments(user.uid);
    }
  }

  void _onCancel(String appointmentId) {
    final cubit = context.read<AppointmentCubit>();

    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Cancel Appointment'),

            content: const Text(
              'Are you sure you want to cancel this appointment?',
            ),

            actions: [
              TextButton(
                onPressed: () => dialogContext.pop(),

                child: const Text('No'),
              ),

              TextButton(
                onPressed: () {
                  dialogContext.pop();

                  cubit.cancelAppointment(appointmentId);
                },

                child: const Text(
                  'Yes, Cancel',

                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  List<AppointmentEntity> _filterAppointments(
    List<AppointmentEntity> appointments,
  ) {
    if (_selectedFilter == 'All') return appointments;

    return appointments
        .where(
          (appt) =>
              appt.status.name.toLowerCase() == _selectedFilter.toLowerCase(),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => context.pop(),
              )
            : null,
        title: const Text(
          'My Appointments',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Filters
          Container(
            height: 60,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = filter == _selectedFilter;
                return Padding(
                  padding: const EdgeInsets.only(
                    right: 8.0,
                    top: 12,
                    bottom: 12,
                  ),
                  child: FilterChip(
                    label: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedFilter = filter),
                    backgroundColor: Colors.grey.shade100,
                    selectedColor: const Color(0xFF1F2937),
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide.none,
                    ),
                  ),
                );
              },
            ),
          ),

          // List
          Expanded(
            child: BlocConsumer<AppointmentCubit, AppointmentState>(
              listener: (context, state) {
                if (state is AppointmentCancelledSuccess) {
                  AppSnackBar.showSuccess(
                    context,
                    'Appointment cancelled successfully',
                  );
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    context.read<AppointmentCubit>().getPatientAppointments(
                      user.uid,
                    );
                  }
                } else if (state is AppointmentError) {
                  AppSnackBar.showError(context, state.message);
                }
              },
              builder: (context, state) {
                if (state is AppointmentLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AppointmentError) {
                  return Center(child: Text(state.message));
                } else if (state is AppointmentsLoaded) {
                  final filteredList = _filterAppointments(state.appointments);

                  if (filteredList.isEmpty) {
                    return const SingleChildScrollView(
                      child: EmptyAppointmentsWidget(),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final appointment = filteredList[index];
                      return AppointmentCard(
                        appointment: appointment,
                        onCancel: () => _onCancel(appointment.id),
                      );
                    },
                  );
                }
                return const Center(child: Text('No Data'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
