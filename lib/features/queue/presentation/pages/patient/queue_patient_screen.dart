import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_entity.dart';
import '../../cubit/queue_patient_cubit.dart';
import '../../cubit/queue_patient_state.dart';

class QueuePatientView extends StatefulWidget {
  const QueuePatientView({super.key});

  @override
  State<QueuePatientView> createState() => _QueuePatientViewState();
}

class _QueuePatientViewState extends State<QueuePatientView> {
  bool _notifyEnabled = true;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<QueuePatientCubit>().watchPatientQueue(user.uid);
    }
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
          'Queue Status',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF0F766E)),
            onPressed: () {
               final user = FirebaseAuth.instance.currentUser;
               if (user != null) {
                 context.read<QueuePatientCubit>().watchPatientQueue(user.uid);
               }
            },
          )
        ],
      ),
      body: BlocBuilder<QueuePatientCubit, QueuePatientState>(
        builder: (context, state) {
          if (state is QueuePatientLoading) {
             return const Center(child: CircularProgressIndicator());
          }

          if (state is QueuePatientError) {
             return Center(child: Text(state.message));
          }

          if (state is QueuePatientLoaded) {
            if (state.queueEntry == null) {
               return const Center(child: Text('You have no active queues today.'));
            }
            
            // Check if patient is medically approved but NOT checked-in physically yet
            if (state.queueEntry!.status.name == 'confirmed' && state.queueEntry!.queueStatus == null) {
               return _buildPreCheckInState(state.queueEntry!);
            }

            return _buildContent(state.queueEntry!, state.patientsAhead);
          }

          return const Center(child: Text('Loading queue...'));
        },
      ),
    );
  }

  Widget _buildPreCheckInState(AppointmentEntity entry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.domain_verification, size: 80, color: Color(0xFF0F766E)),
            const SizedBox(height: 24),
            const Text(
              'Medically Approved',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your appointment is confirmed. Please proceed to the hospital reception to physically check-in and receive your queue number.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Department: ${entry.department}\nTest: ${entry.testType}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildContent(AppointmentEntity entry, int ahead) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text('Last updated: Just now', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
          ),
          const SizedBox(height: 24),
          _buildLiveQueueCircle(entry),
          const SizedBox(height: 32),
          _buildInfoCards(entry, ahead),
          const SizedBox(height: 16),
          _buildNotifySwitch(),
        ],
      ),
    );
  }

  Widget _buildLiveQueueCircle(AppointmentEntity entry) {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F766E).withValues(alpha: 0.05),
            blurRadius: 30,
            spreadRadius: 20,
          )
        ],
        border: Border.all(color: const Color(0xFF0F766E).withValues(alpha: 0.1), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('LIVE QUEUE', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.5)),
          Text(
            '#${entry.queueNumber ?? '?'}',
            style: const TextStyle(fontSize: 70, fontWeight: FontWeight.w900, color: Color(0xFF111827), height: 1.2),
          ),
          Text(
            entry.queueStatus?.name == 'called' ? 'It\'s your turn!' : 'Waiting',
            style: const TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'WAITING AREA',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoCards(AppointmentEntity entry, int ahead) {
    return Column(
      children: [
        _buildCard(
          icon: Icons.access_time,
          iconColor: Colors.orange,
          iconBg: Colors.orange.shade50,
          title: 'EST. WAIT',
          value: ahead > 0 ? '~ ${ahead * 15} Min' : 'Ready',
          trailing: _buildBars(),
        ),
        const SizedBox(height: 16),
        _buildCard(
          icon: Icons.people_outline,
          iconColor: Colors.blue,
          iconBg: Colors.blue.shade50,
          title: 'AHEAD OF YOU',
          value: '$ahead Patients',
          trailing: const SizedBox(),
        ),
        const SizedBox(height: 16),
        _buildCard(
          icon: Icons.monitor_heart_outlined,
          iconColor: const Color(0xFF0F766E),
          iconBg: const Color(0xFFF0FDF4),
          title: entry.department,
          value: entry.testType,
          trailing: Container(
             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
             decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
             child: Text((entry.queueStatus?.name ?? 'WAITING').toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
          ),
        ),
      ],
    );
  }

  Widget _buildCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String value,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF111827))),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildBars() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(width: 6, height: 10, decoration: BoxDecoration(color: Colors.orange.shade200, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 4),
        Container(width: 6, height: 16, decoration: BoxDecoration(color: Colors.orange.shade400, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 4),
        Container(width: 6, height: 24, decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(3))),
      ],
    );
  }

  Widget _buildNotifySwitch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Notify me when it\'s my turn', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          Switch(
            value: _notifyEnabled,
            onChanged: (val) {
              setState(() => _notifyEnabled = val);
            },
            activeTrackColor: const Color(0xFF0F766E).withValues(alpha: 0.5),
            activeThumbColor: const Color(0xFF0F766E),
          )
        ],
      ),
    );
  }
}
