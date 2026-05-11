import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:radiology_and_lab_app/features/home/models/appointment_model.dart';
import 'package:radiology_and_lab_app/features/home/models/nav_item_model.dart';
import 'package:radiology_and_lab_app/features/home/models/quick_action_model.dart';
import 'package:radiology_and_lab_app/features/home/models/recent_activity_model.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_typography.dart';
import 'widgets/appointment_card.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/home_bottom_nav_bar.dart';
import 'widgets/live_queue_banner.dart';
import 'widgets/quick_actions_grid.dart';
import 'widgets/recent_activity_section.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // ── App bar ──────────────────────────────────────────────────────
          HomeAppBar(
            greeting: AppStrings.homeGreeting,
            patientName: AppStrings.patientName,
            avatarInitials: AppStrings.avatarInitials,
          ),

          // ── Scrollable content ───────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // Section: Upcoming Appointment
                  Text(
                    AppStrings.upcomingAppointment,
                    style: AppTypography.sectionTitle,
                  ),
                  const SizedBox(height: 12),
                  AppointmentCard(
                    appointment: const AppointmentModel(
                      date: AppStrings.apptDate,
                      time: AppStrings.apptTime,
                      amPm: AppStrings.apptAmPm,
                      title: AppStrings.apptTitle,
                      doctorName: AppStrings.apptDoctor,
                      isConfirmed: true,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Live Queue banner
                  LiveQueueBanner(queueNumber: 3, onTap: () {}),
                  const SizedBox(height: 24),

                  // Section: Quick Actions
                  Text(
                    AppStrings.quickActions,
                    style: AppTypography.sectionTitle,
                  ),
                  const SizedBox(height: 12),
                  QuickActionsGrid(
                    actions: const [
                      QuickActionModel(
                        label: AppStrings.qaBookAppt,
                        iconData: Icons.calendar_today_outlined,
                        iconColor: AppColors.primary,
                        iconBgColor: AppColors.chipTeal,
                        route: '/book-appointment',
                      ),
                      QuickActionModel(
                        label: AppStrings.qaResults,
                        iconData: Icons.description_outlined,
                        iconColor: AppColors.progressBlue,
                        iconBgColor: AppColors.chipBlue,
                        route: '/results',
                      ),
                      QuickActionModel(
                        label: AppStrings.qaAlerts,
                        iconData: Icons.notifications_outlined,
                        iconColor: AppColors.chipPurpleIcon,
                        iconBgColor: AppColors.chipPurple,
                        route: '/alerts',
                      ),
                      QuickActionModel(
                        label: AppStrings.qaMyAppts,
                        iconData: Icons.access_time_rounded,
                        iconColor: AppColors.chipOrangeIcon,
                        iconBgColor: AppColors.chipOrange,
                        route: '/my-appointments',
                      ),
                    ],
                    onActionTap: (val) {},
                  ),
                  const SizedBox(height: 24),

                  // Section: Recent Activity
                  RecentActivitySection(
                    activities: const [
                      RecentActivityModel(
                        title: 'CBC Result Ready',
                        subtitle:
                            'Your laboratory results are now available for download.',
                        timeAgo: '2 hours ago',
                        iconData: Icons.check_circle,
                        iconColor: AppColors.primary,
                        iconBgColor: AppColors.chipTeal,
                      ),

                      RecentActivityModel(
                        title: 'CBC Result Ready',
                        subtitle:
                            'Your laboratory results are now available for download.',
                        timeAgo: '2 hours ago',
                        iconData: Icons.check_circle,
                        iconColor: AppColors.primary,
                        iconBgColor: AppColors.chipTeal,
                      ),

                      RecentActivityModel(
                        title: 'CBC Result Ready',
                        subtitle:
                            'Your laboratory results are now available for download.',
                        timeAgo: '2 hours ago',
                        iconData: Icons.check_circle,
                        iconColor: AppColors.primary,
                        iconBgColor: AppColors.chipTeal,
                      ),
                    ],
                    onSeeAllTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
