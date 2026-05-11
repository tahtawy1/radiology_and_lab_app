import 'package:flutter/material.dart';

/// Represents one item in the bottom navigation bar.
class NavItemModel {
  const NavItemModel({
    required this.label,
    required this.iconData,
  });

  final String label;
  final IconData iconData;
}
