import 'package:flutter/material.dart';

/// Design tokens extracted from the patient Home View design.
abstract final class AppColors {
  // ── Brand / Primary ───────────────────────────────────────────────────────
  static const Color primary = Color(0xFF0F766E);
  static const Color primaryLight = Color(0xFF14B8A6);
  static const Color primarySubtle = Color(0xFF00BBA7);

  // ── Appointment card ──────────────────────────────────────────────────────
  static const Color apptCardBg = Color(0xFF0F6B60);      // deep teal card
  static const Color apptCardDark = Color(0xFF0A4F47);    // darker accent strip
  static const Color apptConfirmedBadge = Color(0xFF4ECDC4); // light teal badge

  // ── Live queue banner ─────────────────────────────────────────────────────
  static const Color queueBannerBg = Color(0xFFFFFBEB);   // warm cream
  static const Color queueBannerBorder = Color(0xFFFDE68A); // amber border
  static const Color queueLiveGreen = Color(0xFF22C55E);  // pulsing live dot

  // ── Background ────────────────────────────────────────────────────────────
  static const Color scaffoldBg = Color(0xFFF8FAFC);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFF1F5F9);
  static const Color sectionHeaderBg = Color(0x80F8FAFC);
  static const Color chipBg = Color(0xFFF1F5F9);

  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color textDark = Color(0xFF1D293D);
  static const Color textDark2 = Color(0xFF0F172B);
  static const Color textMedium = Color(0xFF45556C);
  static const Color textGray = Color(0xFF62748E);
  static const Color textMuted = Color(0xFF90A1B9);
  static const Color textSubheading = Color(0xFF314158);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color headerSubtitle = Color(0xFFCBFBF1);

  // ── Status / Semantic ─────────────────────────────────────────────────────
  static const Color success = Color(0xFF00C950);
  static const Color danger = Color(0xFFFB2C36);
  static const Color dangerDark = Color(0xFFE7000B);
  static const Color warning = Color(0xFFF54900);
  static const Color warningBar = Color(0xFFFF6900);
  static const Color progressBlue = Color(0xFF2B7FFF);

  // ── Icon chip backgrounds ─────────────────────────────────────────────────
  static const Color chipBlue = Color(0xFFEFF6FF);
  static const Color chipOrange = Color(0xFFFFF7ED);
  static const Color chipGreen = Color(0xFFF0FDF4);
  static const Color chipPurple = Color(0xFFFAF5FF);
  static const Color chipTeal = Color(0xFFF0FDFA);

  // ── Icon colors inside chips ──────────────────────────────────────────────
  static const Color chipPurpleIcon = Color(0xFF9333EA);
  static const Color chipOrangeIcon = Color(0xFFF59E0B);

  // ── Glassmorphism ─────────────────────────────────────────────────────────
  static const Color glassWhite20 = Color(0x33FFFFFF);
  static const Color glassWhiteBorder = Color(0x33FFFFFF);

  // ── Nav bar ───────────────────────────────────────────────────────────────
  static const Color navActive = Color(0xFF0F766E);
  static const Color navInactive = Color(0xFF90A1B9);
}
