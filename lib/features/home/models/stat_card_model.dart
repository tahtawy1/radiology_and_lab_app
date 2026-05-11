import 'package:flutter/material.dart';

/// Data model representing one stat card in the 2×2 dashboard grid.
class StatCardModel {
  const StatCardModel({
    required this.label,
    required this.value,
    required this.trend,
    required this.iconBgColor,
    required this.iconData,
    required this.trendColor,
    this.trendIsUp = true,
  });

  final String label;
  final String value;
  final String trend;
  final Color iconBgColor;
  final IconData iconData;
  final Color trendColor;
  final bool trendIsUp;
}
