import 'package:flutter/material.dart';

/// Represents one quick-action tile in the 2×2 grid.
class QuickActionModel {
  const QuickActionModel({
    required this.label,
    required this.iconData,
    required this.iconColor,
    required this.iconBgColor,
    required this.route,
  });

  final String label;
  final IconData iconData;
  final Color iconColor;
  final Color iconBgColor;
  final String route;
}
