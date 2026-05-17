import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:radiology_and_lab_app/core/constants/app_colors.dart';
import 'package:radiology_and_lab_app/core/constants/app_strings.dart';
import 'package:radiology_and_lab_app/features/auth/domain/entities/user_entity.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/cubit/appointment_cubit.dart';

import '../../widgets/shared/dashboard_header.dart';
import '../../widgets/shared/dashboard_section_title.dart';
import '../../widgets/doctor/doctor_summary_cards.dart';
import '../../widgets/doctor/doctor_quick_actions.dart';
import '../../widgets/doctor/pending_requests_section.dart';

class DoctorDashboardScreen extends StatefulWidget {
  final UserEntity user;
  const DoctorDashboardScreen({super.key, required this.user});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<AppointmentCubit>().getPendingAppointmentsForDoctor(
      widget.user.id,
    );
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
                name: 'Dr. ${widget.user.fullName}',
                roleLabel: '🩺 Doctor',
                onAvatarTap: () {},
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const DoctorSummaryCards(),
                  const SizedBox(height: 24),
                  const DashboardSectionTitle(title: 'Quick Actions'),
                  const SizedBox(height: 14),
                  const DoctorQuickActions(),
                  const SizedBox(height: 24),
                  DashboardSectionTitle(
                    title: 'Pending Requests',
                    actionLabel: 'See All',
                    onAction: () async {
                      await context.push(
                        AppStrings.doctorApprovalRoute,
                        extra: {'showBackButton': true},
                      );
                      if (context.mounted) {
                        _loadData();
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  const PendingRequestsSection(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
