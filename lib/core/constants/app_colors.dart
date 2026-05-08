import 'dart:ui';

/// All colour tokens extracted directly from the Figma Splash Screen frame.
abstract final class AppColors {
  // ── Background gradient stops ──────────────────────────────────────────────
  static const Color gradientTop = Color(0xFF0F766E);
  static const Color gradientMid = Color(0xFF14B8A6);
  static const Color gradientBottom = Color(0xFF0D5F58);

  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color subtitleTeal = Color(0xFFCBFBF1); // #cbfbf1

  // ── Glassmorphism surfaces ─────────────────────────────────────────────────
  static const Color glassWhite10 = Color(0x1AFFFFFF); // rgba(255,255,255,0.10)
  static const Color glassWhite20 = Color(0x33FFFFFF); // rgba(255,255,255,0.20)
  static const Color glassBorder = Color(0x33FFFFFF);  // rgba(255,255,255,0.20)
  static const Color badgeBorder = Color(0x1AFFFFFF);  // rgba(255,255,255,0.10)
  static const Color badgeText = Color(0xE6FFFFFF);    // rgba(255,255,255,0.90)

  // ── Progress indicator ────────────────────────────────────────────────────
  static const Color progressActive = Color(0xFFFFFFFF);
  static const Color progressInactive = Color(0x33FFFFFF); // rgba(255,255,255,0.20)

  // ── Decorative blobs ──────────────────────────────────────────────────────
  static const Color blobColor = Color(0x1AFFFFFF); // rgba(255,255,255,0.10)
}
