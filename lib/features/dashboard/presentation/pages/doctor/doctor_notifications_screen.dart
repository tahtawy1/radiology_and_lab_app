import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:radiology_and_lab_app/core/constants/app_colors.dart';
import '../../widgets/doctor/notification_card.dart';

class DoctorNotificationsScreen extends StatelessWidget {
  const DoctorNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock notifications for design showcase
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'New Appointment Request',
        'message': 'John Doe has requested an appointment for tomorrow at 10:00 AM.',
        'time': 'Just now',
        'icon': Icons.calendar_today_rounded,
        'iconColor': AppColors.primaryDark,
        'isUnread': true,
      },
      {
        'title': 'Lab Results Ready',
        'message': 'The blood test results for Sarah Smith are now available for review.',
        'time': '2 hours ago',
        'icon': Icons.science_rounded,
        'iconColor': Colors.blue,
        'isUnread': true,
      },
      {
        'title': 'Message from Patient',
        'message': 'Mike Johnson sent a message regarding his recent prescription.',
        'time': '5 hours ago',
        'icon': Icons.message_rounded,
        'iconColor': Colors.orange,
        'isUnread': false,
      },
      {
        'title': 'System Update',
        'message': 'The Radiology system will undergo maintenance tonight at 2:00 AM.',
        'time': '1 day ago',
        'icon': Icons.system_update_rounded,
        'iconColor': AppColors.textSecondary,
        'isUnread': false,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.gradientTop, AppColors.gradientMid],
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all_rounded, color: AppColors.white),
            tooltip: 'Mark all as read',
            onPressed: () {
              // Add mark all as read logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications marked as read')),
              );
            },
          ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationCard(
                  title: notification['title'],
                  message: notification['message'],
                  time: notification['time'],
                  icon: notification['icon'],
                  iconColor: notification['iconColor'],
                  isUnread: notification['isUnread'],
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_off_outlined,
              size: 64,
              color: AppColors.primaryLight,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'When you get notifications, they will\nshow up here',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
