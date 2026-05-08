import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography tokens extracted from the Figma Splash Screen frame.
/// All fonts use the Poppins family at their specified weights.
abstract final class AppTypography {
  // ── Title line 1 – "Radiology & Lab"  (Bold, 30 sp, tracking -0.75) ───────
  static TextStyle titleBold = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
    letterSpacing: -0.75,
    height: 36 / 30, // line-height 36px
  );

  // ── Title line 2 – "System"  (Light, 30 sp, tracking -0.75) ──────────────
  static TextStyle titleLight = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w300,
    color: AppColors.white,
    letterSpacing: -0.75,
    height: 36 / 30,
  );

  // ── Subtitle – "Smart Healthcare, Simplified"  (Regular, 18 sp) ───────────
  static TextStyle subtitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.subtitleTeal,
    height: 28 / 18,
  );

  // ── Hospital badge text  (Medium, 12 sp, tracking 0.3) ───────────────────
  static TextStyle badge = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.badgeText,
    letterSpacing: 0.3,
    height: 16 / 12,
  );

  // ── Status bar time  (Medium, 14 sp) ─────────────────────────────────────
  static TextStyle statusBarTime = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
    height: 20 / 14,
  );
}
