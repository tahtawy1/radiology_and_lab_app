import 'package:flutter/material.dart';

/// Represents one progress row in the Today's Activity card.
class ActivityModel {
  const ActivityModel({
    required this.label,
    required this.percentage,
    required this.barColor,
  });

  final String label;
  final double percentage; // 0.0 – 1.0
  final Color barColor;
}
