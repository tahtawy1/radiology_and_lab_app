import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/widgets/app_snackbar.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_entity.dart';
import '../../cubit/queue_admin_cubit.dart';
import '../../cubit/queue_admin_state.dart';

class QueueAdminView extends StatefulWidget {
  final String department;
  final bool showBackButton;

  const QueueAdminView({
    super.key,
    this.department = 'Radiology',
    this.showBackButton = false,
  });

  @override
  State<QueueAdminView> createState() => _QueueAdminViewState();
}

class _QueueAdminViewState extends State<QueueAdminView> {
  @override
  void initState() {
    super.initState();
    context.read<QueueAdminCubit>().fetchQueue(department: widget.department);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading:
            widget.showBackButton
                ? IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 20,
                  ),
                  onPressed: () => context.pop(),
                )
                : null,
        title: const Text(
          'Queue Management',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: BlocConsumer<QueueAdminCubit, QueueAdminState>(
        listener: (context, state) {
          if (state is QueueAdminError) {
            AppSnackBar.showError(context, state.message);
          } else if (state is QueueAdminActionSuccess) {
            AppSnackBar.showSuccess(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is QueueAdminLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is QueueAdminLoaded) {
            return RefreshIndicator(
              onRefresh:
                  () async => context.read<QueueAdminCubit>().fetchQueue(
                    department: widget.department,
                  ),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildStatsRow(state),
                  const SizedBox(height: 24),

                  // SECTION 1: Confirmed Appointments (Pending Check-In)
                  const Text(
                    'Pending Check-In',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...state.queueEntries
                      .where(
                        (e) =>
                            e.status.name == 'confirmed' &&
                            e.queueStatus == null,
                      )
                      .map((e) => _buildConfirmedCard(context, e)),

                  const SizedBox(height: 24),

                  // SECTION 2: Active Queue
                  const Text(
                    'Active Queue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildCallNextButton(context),
                  const SizedBox(height: 16),
                  ...state.queueEntries
                      .where((e) => e.queueStatus != null)
                      .map((e) => _buildPatientCard(context, e)),
                ],
              ),
            );
          }

          return const Center(child: Text('No Data'));
        },
      ),
    );
  }

  Widget _buildStatsRow(QueueAdminLoaded state) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Today',
            state.totalToday.toString(),
            Colors.black,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard('Called', state.called.toString(), Colors.blue),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            'Served',
            state.served.toString(),
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallNextButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () {
          context.read<QueueAdminCubit>().callNextPatient(
            department: widget.department,
          );
        },
        icon: const Icon(
          Icons.notifications_active_outlined,
          color: Colors.white,
        ),
        label: const Text(
          'Call Next Patient',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0F766E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // Card for patients who are confirmed medically but not yet in the physical queue
  Widget _buildConfirmedCard(BuildContext context, AppointmentEntity entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.patientName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      entry.testType,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Confirmed',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Appointment: ${DateFormat('hh:mm a').format(entry.appointmentDateTime)}',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.read<QueueAdminCubit>().checkInPatient(
                  appointmentId: entry.id,
                  department: widget.department,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F766E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Check-In to Queue',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Card for patients actively in the queue
  Widget _buildPatientCard(BuildContext context, AppointmentEntity entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF0F766E),
                radius: 20,
                child: Text(
                  '#${entry.queueNumber ?? '?'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.patientName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      entry.testType,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(entry.queueStatus?.name ?? 'unknown'),
            ],
          ),
          if (entry.queueStatus?.name == 'waiting' ||
              entry.queueStatus?.name == 'called') ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.read<QueueAdminCubit>().markServed(
                        appointmentId: entry.id,
                        department: widget.department,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF0F766E)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Mark Served',
                      style: TextStyle(color: Color(0xFF0F766E)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: () {
                    context.read<QueueAdminCubit>().markNoShow(
                      appointmentId: entry.id,
                      department: widget.department,
                    );
                  },
                  child: const Text(
                    'No Show',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ] else if (entry.queueStatus?.name == 'served') ...[
            const SizedBox(height: 12),
            const Row(
              children: [
                Icon(Icons.check, color: Colors.green, size: 16),
                SizedBox(width: 4),
                Text(
                  'Served',
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    String text;

    switch (status) {
      case 'called':
        bgColor = const Color(0xFFDBEAFE);
        textColor = const Color(0xFF1D4ED8);
        text = 'Called';
        break;
      case 'waiting':
        bgColor = const Color(0xFFFEF3C7);
        textColor = const Color(0xFFB45309);
        text = 'Waiting';
        break;
      case 'served':
        bgColor = const Color(0xFFD1FAE5);
        textColor = const Color(0xFF047857);
        text = 'Served';
        break;
      case 'no_show':
        bgColor = const Color(0xFFFEE2E2);
        textColor = const Color(0xFFB91C1C);
        text = 'No Show';
        break;
      default:
        bgColor = Colors.grey.shade200;
        textColor = Colors.grey.shade700;
        text = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
