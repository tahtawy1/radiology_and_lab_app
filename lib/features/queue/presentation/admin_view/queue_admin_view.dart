import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_snackbar.dart';
import '../../domain/entities/queue_entry_entity.dart';
import 'cubit/queue_admin_cubit.dart';

class QueueAdminView extends StatefulWidget {
  final String department;

  const QueueAdminView({super.key, this.department = 'Radiology'});

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Queue Management',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
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
              onRefresh: () => context.read<QueueAdminCubit>().fetchQueue(department: widget.department),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildStatsRow(state),
                  const SizedBox(height: 16),
                  _buildCallNextButton(context),
                  const SizedBox(height: 16),
                  ...state.queueEntries.map((e) => _buildPatientCard(context, e)),
                ],
              ),
            );
          }

          return const Center(child: Text('No Data'));
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildStatsRow(QueueAdminLoaded state) {
    return Row(
      children: [
        Expanded(child: _buildStatCard('Total Today', state.totalToday.toString(), Colors.black)),
        const SizedBox(width: 8),
        Expanded(child: _buildStatCard('In Progress', state.inProgress.toString(), Colors.blue)),
        const SizedBox(width: 8),
        Expanded(child: _buildStatCard('Completed', state.completed.toString(), Colors.green)),
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
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.bold, fontSize: 20)),
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
          context.read<QueueAdminCubit>().callNextPatient(department: widget.department);
        },
        icon: const Icon(Icons.notifications_active_outlined, color: Colors.white),
        label: const Text('Call Next Patient', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0F766E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildPatientCard(BuildContext context, QueueEntryEntity entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF0F766E),
                radius: 20,
                child: Text('#${entry.queueNumber}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.patientName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(entry.testType, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                  ],
                ),
              ),
              _buildStatusBadge(entry.queueStatus),
            ],
          ),
          if (entry.queueStatus == 'waiting' || entry.queueStatus == 'in_progress') ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.read<QueueAdminCubit>().markDone(queueEntryId: entry.id, department: widget.department);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF0F766E)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Mark Done', style: TextStyle(color: Color(0xFF0F766E))),
                  ),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: () {
                    context.read<QueueAdminCubit>().markNoShow(queueEntryId: entry.id, department: widget.department);
                  },
                  child: const Text('No Show', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ] else if (entry.queueStatus == 'completed') ...[
            const SizedBox(height: 12),
            const Row(
              children: [
                Icon(Icons.check, color: Colors.green, size: 16),
                SizedBox(width: 4),
                Text('Checked out', style: TextStyle(color: Colors.green, fontSize: 12)),
              ],
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    String text;

    switch (status) {
      case 'in_progress':
        bgColor = const Color(0xFFDBEAFE);
        textColor = const Color(0xFF1D4ED8);
        text = 'In Progress';
        break;
      case 'waiting':
        bgColor = const Color(0xFFFEF3C7);
        textColor = const Color(0xFFB45309);
        text = 'Waiting';
        break;
      case 'completed':
        bgColor = const Color(0xFFD1FAE5);
        textColor = const Color(0xFF047857);
        text = 'Completed';
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
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Text(text, style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF0F766E),
      unselectedItemColor: Colors.grey.shade500,
      currentIndex: 1, // Queue
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.queue_outlined), label: 'Queue'),
        BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Users'),
      ],
    );
  }
}
