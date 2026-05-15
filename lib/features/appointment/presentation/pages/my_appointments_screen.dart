import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_entity.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/cubit/appointment_cubit.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/cubit/appointment_state.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/widgets/appointment_card.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/widgets/empty_appointments_widget.dart';
import 'package:radiology_and_lab_app/shared/widgets/app_snackbar.dart';

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Confirmed', 'Pending', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    // Fetch appointments for the current user
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<AppointmentCubit>().getPatientAppointments(user.uid);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

  void _onReschedule(String appointmentId) {
    AppSnackBar.showInfo(context, 'Coming soon');
  }

  List<AppointmentEntity> _filterAppointments(
    List<AppointmentEntity> appointments,
    bool isUpcoming,
  ) {
    final now = DateTime.now();
    return appointments.where((appt) {
      final matchesTab =
          isUpcoming
              ? appt.appointmentDateTime.isAfter(now)
              : appt.appointmentDateTime.isBefore(now);
      final matchesFilter =
          _selectedFilter == 'All' ||
          appt.status.toLowerCase() == _selectedFilter.toLowerCase();
      return matchesTab && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'My Appointments',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF0D9488),
              unselectedLabelColor: Colors.grey.shade600,
              indicatorColor: const Color(0xFF0D9488),
              indicatorWeight: 2,
              tabs: const [Tab(text: 'Upcoming'), Tab(text: 'Past')],
            ),
          ),
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
                  final isUpcoming = _tabController.index == 0;
                  final filteredList = _filterAppointments(
                    state.appointments,
                    isUpcoming,
                  );

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
                        onReschedule: () => _onReschedule(appointment.id),
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
