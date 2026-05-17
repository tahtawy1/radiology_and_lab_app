import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/cubit/appointment_cubit.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/cubit/appointment_state.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/widgets/doctor/doctor_approval_card.dart';
import 'package:radiology_and_lab_app/shared/widgets/app_snackbar.dart';

class DoctorApprovalScreen extends StatefulWidget {
  const DoctorApprovalScreen({super.key});

  @override
  State<DoctorApprovalScreen> createState() => _DoctorApprovalScreenState();
}

class _DoctorApprovalScreenState extends State<DoctorApprovalScreen> {
  @override
  void initState() {
    super.initState();
    _fetchPendingAppointments();
  }

  void _fetchPendingAppointments() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<AppointmentCubit>().getPendingAppointmentsForDoctor(
        user.uid,
      );
    }
  }

  void _onApprove(String appointmentId, String patientId) {
    context.read<AppointmentCubit>().approveAppointment(
      appointmentId,
      patientId: patientId,
    );
  }

  void _onReject(String appointmentId, String patientId) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Reject Appointment'),
            content: const Text(
              'Are you sure you want to reject this appointment?',
            ),
            actions: [
              TextButton(
                onPressed: () => dialogContext.pop(),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  dialogContext.pop();
                  context.read<AppointmentCubit>().rejectAppointment(
                    appointmentId,
                    patientId: patientId,
                  );
                },
                child: const Text(
                  'Yes, Reject',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
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
          'Pending Approvals',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<AppointmentCubit, AppointmentState>(
        listener: (context, state) {
          if (state is AppointmentStatusUpdatedSuccess) {
            AppSnackBar.showSuccess(
              context,
              'Appointment updated successfully',
            );
            _fetchPendingAppointments();
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
            final appointments = state.appointments;

            if (appointments.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_rounded,
                      size: 80,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No pending approvals',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'You have no pending appointment requests.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return DoctorApprovalCard(
                  appointment: appointment,
                  onApprove: () => _onApprove(appointment.id, appointment.patientId),
                  onReject: () => _onReject(appointment.id, appointment.patientId),
                );
              },
            );
          }
          return const Center(child: Text('No Data'));
        },
      ),
    );
  }
}
