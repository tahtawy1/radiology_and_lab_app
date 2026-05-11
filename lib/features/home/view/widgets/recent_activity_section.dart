import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_typography.dart';
import '../../models/recent_activity_model.dart';

/// Recent Activity section header + list.
class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({
    super.key,
    required this.activities,
    required this.onSeeAllTap,
  });

  final List<RecentActivityModel> activities;
  final VoidCallback onSeeAllTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppStrings.recentActivity, style: AppTypography.sectionTitle),
            GestureDetector(
              onTap: onSeeAllTap,
              child: Text(AppStrings.seeAll, style: AppTypography.seeAll),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Activity rows
        ...activities.map(
          (a) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: RecentActivityRow(activity: a),
          ),
        ),
      ],
    );
  }
}

/// Single recent-activity row with icon, title/subtitle, and time.
class RecentActivityRow extends StatelessWidget {
  const RecentActivityRow({super.key, required this.activity});

  final RecentActivityModel activity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon chip
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: activity.iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(activity.iconData, color: activity.iconColor, size: 20),
          ),
          const SizedBox(width: 12),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(activity.title, style: AppTypography.activityTitle),
                    Text(activity.timeAgo, style: AppTypography.activityTime),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  activity.subtitle,
                  style: AppTypography.activitySubtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
