import 'package:flutter/material.dart';

/// Represents one department row in the Live Queue Management card.
class QueueItemModel {
  const QueueItemModel({
    required this.departmentName,
    required this.statusText,
    required this.iconData,
    required this.iconBgColor,
    required this.capacityLabel,
    required this.capacityColor,
    required this.capacityProgress, // 0.0 – 1.0
    required this.barColor,
  });

  final String departmentName;
  final String statusText;
  final IconData iconData;
  final Color iconBgColor;
  final String capacityLabel;
  final Color capacityColor;
  final double capacityProgress;
  final Color barColor;
}
