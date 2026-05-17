import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:radiology_and_lab_app/core/constants/app_colors.dart';
import 'package:radiology_and_lab_app/core/constants/app_strings.dart';
import 'package:radiology_and_lab_app/features/auth/domain/entities/user_entity.dart';
import 'package:radiology_and_lab_app/features/queue/presentation/cubit/queue_admin_cubit.dart';

import '../../widgets/shared/dashboard_header.dart';
import '../../widgets/shared/dashboard_section_title.dart';
import '../../widgets/admin/admin_queue_summary.dart';
import '../../widgets/admin/admin_actions_grid.dart';
import '../../widgets/admin/active_queue_preview.dart';
import '../../widgets/admin/recent_uploads_section.dart';


class AdminDashboardScreen extends StatefulWidget {
  final UserEntity user;
  final String department;

  const AdminDashboardScreen({
    super.key,
    required this.user,
    this.department = 'Radiology', // MVP default
  });

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<QueueAdminCubit>().fetchQueue(department: widget.department);
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
                greeting: 'Reception Desk',
                name: widget.user.fullName,
                roleLabel: '🏥 ${widget.department} Admin',
                showNotification: true,
                onNotificationTap: () => context.push(AppStrings.notificationsRoute),
                onAvatarTap: () {},
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildLiveIndicator(),
                  const SizedBox(height: 16),
                  const AdminQueueSummary(),
                  const SizedBox(height: 24),
                  const DashboardSectionTitle(title: 'Quick Actions'),
                  const SizedBox(height: 14),
                  AdminActionsGrid(department: widget.department),
                  const SizedBox(height: 24),
                  DashboardSectionTitle(
                    title: 'Live Queue Preview',
                    actionLabel: 'Manage',
                    onAction: () => context.go(AppStrings.queueAdminRoute),
                  ),
                  const SizedBox(height: 14),
                  const ActiveQueuePreview(),
                  const SizedBox(height: 24),
                  const DashboardSectionTitle(title: 'Recent Uploads'),
                  const SizedBox(height: 14),
                  const RecentUploadsSection(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.successGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.successGreen.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.successGreen,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Queue is LIVE',
            style: TextStyle(
              color: AppColors.successGreen,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const Spacer(),
          Text(
            'Today',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.successGreen.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
