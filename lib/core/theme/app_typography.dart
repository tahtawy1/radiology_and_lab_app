import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// All text style tokens for the patient Home screen.
abstract final class AppTypography {
  // ── Header ───────────────────────────────────────────────────────────────
  static TextStyle headerGreeting = const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textGray,
    height: 18 / 13,
  );

  static TextStyle headerName = const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    height: 30 / 22,
  );

  static TextStyle avatarLabel = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    height: 22 / 15,
  );

  // ── Section title ─────────────────────────────────────────────────────────
  static TextStyle sectionTitle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    height: 24 / 16,
  );

  // ── Appointment card ──────────────────────────────────────────────────────
  static TextStyle apptDate = const TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
    height: 16 / 11,
  );

  static TextStyle apptTime = const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.textWhite,
    height: 1.1,
  );

  static TextStyle apptAmPm = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.headerSubtitle,
    height: 16 / 12,
  );

  static TextStyle apptTitle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
    height: 28 / 20,
  );

  static TextStyle apptDoctor = const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.headerSubtitle,
    height: 18 / 13,
  );

  static TextStyle apptConfirmedBadge = const TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
    height: 15 / 11,
  );

  // ── Live queue banner ─────────────────────────────────────────────────────
  static TextStyle queueLiveLabel = const TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: AppColors.success,
    letterSpacing: 0.6,
    height: 14 / 10,
  );

  static TextStyle queueText = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    height: 20 / 14,
  );

  // ── Quick action tile ─────────────────────────────────────────────────────
  static TextStyle quickActionLabel = const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    height: 18 / 13,
  );

  // ── Recent activity ───────────────────────────────────────────────────────
  static TextStyle activityTitle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    height: 20 / 14,
  );

  static TextStyle activitySubtitle = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textGray,
    height: 18 / 12,
  );

  static TextStyle activityTime = const TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 15 / 11,
  );

  // ── See All link ──────────────────────────────────────────────────────────
  static TextStyle seeAll = const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    height: 18 / 13,
  );

  // ── Bottom nav ───────────────────────────────────────────────────────────
  static TextStyle navLabel = const TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 14 / 10,
  );
}
