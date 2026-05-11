import 'package:flutter/material.dart';

/// Represents one row in the System Reports card.
class ReportItemModel {
  const ReportItemModel({
    required this.title,
    required this.subtitle,
    required this.iconData,
  });

  final String title;
  final String subtitle;
  final IconData iconData;
}
