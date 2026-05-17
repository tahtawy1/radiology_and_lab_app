import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:radiology_and_lab_app/core/constants/app_colors.dart';
import 'package:radiology_and_lab_app/core/constants/app_strings.dart';
import 'package:radiology_and_lab_app/features/auth/domain/entities/user_entity.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/cubit/appointment_cubit.dart';
import 'package:radiology_and_lab_app/features/queue/presentation/cubit/queue_patient_cubit.dart';

import '../../widgets/shared/dashboard_header.dart';
import '../../widgets/shared/dashboard_section_title.dart';
import '../../widgets/patient/live_queue_card.dart';
import '../../widgets/patient/upcoming_appointment_card.dart';
import '../../widgets/patient/patient_quick_actions.dart';
import '../../widgets/patient/patient_statistics_section.dart';
import '../../widgets/patient/recent_activity_list.dart';

class PatientDashboardScreen extends StatefulWidget {
  final UserEntity user;
  const PatientDashboardScreen({super.key, required this.user});

  @override
  State<PatientDashboardScreen> createState() => _PatientDashboardScreenState();
}

class _PatientDashboardScreenState extends State<PatientDashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<AppointmentCubit>().getPatientAppointments(widget.user.id);
    context.read<QueuePatientCubit>().watchPatientQueue(widget.user.id);
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: RefreshIndicator(
        color: AppColors.primaryDark,
        onRefresh: () async => _loadData(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: DashboardHeader(
                greeting: _greeting(),
                name: widget.user.fullName,
                roleLabel: '🏥 Patient',
                onAvatarTap: () {},
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const LiveQueueCard(),
                  const UpcomingAppointmentCard(),
                  const SizedBox(height: 24),
                  const DashboardSectionTitle(title: 'Statistics'),
                  const SizedBox(height: 14),
                  const PatientStatisticsSection(),
                  const SizedBox(height: 24),
                  const DashboardSectionTitle(title: 'Quick Actions'),
                  const SizedBox(height: 14),
                  const PatientQuickActions(),
                  const SizedBox(height: 24),
                  const DashboardSectionTitle(title: 'Recent Activity'),
                  const SizedBox(height: 14),
                  const RecentActivityList(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
