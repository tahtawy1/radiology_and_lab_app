import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_strings.dart';
import 'package:radiology_and_lab_app/core/services/user_session_service.dart';
import '../../cubit/results_cubit.dart';
import '../../cubit/results_state.dart';
import '../../widgets/admin/served_patient_card.dart';
import '../../widgets/admin/empty_served_patients_widget.dart';

class ServedPatientsResultsScreen extends StatefulWidget {
  const ServedPatientsResultsScreen({super.key});

  @override
  State<ServedPatientsResultsScreen> createState() =>
      _ServedPatientsResultsScreenState();
}

class _ServedPatientsResultsScreenState
    extends State<ServedPatientsResultsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ResultsCubit>().getServedPatients();
  }

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
          'Served Patients',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF0D9488)),
            onPressed: () => context.read<ResultsCubit>().getServedPatients(),
          ),
        ],
      ),
      body: BlocBuilder<ResultsCubit, ResultsState>(
        builder: (context, state) {
          if (state is ResultsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF0D9488)),
            );
          }

          if (state is ResultsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFF6B7280)),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        () => context.read<ResultsCubit>().getServedPatients(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D9488),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ServedPatientsLoaded) {
            final appointments = state.appointments;

            if (appointments.isEmpty) {
              return const EmptyServedPatientsWidget();
            }

            return RefreshIndicator(
              onRefresh:
                  () async => context.read<ResultsCubit>().getServedPatients(),
              color: const Color(0xFF0D9488),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final appointment = appointments[index];
                  return ServedPatientCard(
                    appointment: appointment,
                    onUploadPressed: () {
                      context.push(
                        AppStrings.uploadResultRoute,
                        extra: {
                          'appointmentId': appointment.id,
                          'patientName': appointment.patientName,
                          'testType': appointment.testType,
                        },
                      );
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
