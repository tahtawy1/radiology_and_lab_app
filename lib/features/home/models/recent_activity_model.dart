import 'package:flutter/material.dart';

/// Represents one row in the Recent Activity list.
class RecentActivityModel {
  const RecentActivityModel({
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    required this.iconData,
    required this.iconColor,
    required this.iconBgColor,
  });

  final String title;
  final String subtitle;
  final String timeAgo;
  final IconData iconData;
  final Color iconColor;
  final Color iconBgColor;
}
