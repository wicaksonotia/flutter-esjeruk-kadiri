import 'package:flutter/cupertino.dart';

class MyColors {
  // ============================================================
  // BRAND
  // ============================================================

  /// Warna utama aplikasi — soft sage green
  static const Color primary = Color(0xFF7F9862);

  /// Primary yang lebih terang untuk surface / selected state
  static const Color primaryLight = Color(0xFFE9EEE2);

  /// Primary yang lebih gelap untuk pressed / active
  static const Color primaryDark = Color(0xFF63794D);

  // ============================================================
  // ACCENT
  // ============================================================

  /// Warm beige — accent / secondary action
  static const Color secondary = Color(0xFFD8CDB8);

  /// Muted red — error / delete
  static const Color red = Color(0xFFC76A68);

  /// Muted blue — info
  static const Color blue = Color(0xFF6689A0);

  /// Soft amber — warning
  static const Color yellow = Color(0xFFD1AA61);

  /// Neutral grey
  static const Color grey = Color(0xFF989B93);

  // ============================================================
  // TEXT
  // ============================================================

  /// Soft charcoal — jangan gunakan hitam pekat
  static const Color textDark = Color(0xFF282C26);

  static const Color textPrimary = Color(0xFF282C26);

  static const Color textSecondary = Color(0xFF73786F);

  static const Color textMuted = Color(0xFFA1A49D);

  /// Text di atas primary / button
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ============================================================
  // BACKGROUND
  // ============================================================

  /// Background utama — warm off-white
  static const Color background = Color(0xFFF8F8F5);

  /// Surface / card
  static const Color surface = Color(0xFFFFFFFF);

  /// Soft surface — drawer / secondary card / subtle section
  static const Color surfaceSoft = Color(0xFFF1F3EC);

  /// Border yang sangat subtle
  static const Color border = Color(0xFFE2E5DD);

  /// Divider
  static const Color divider = Color(0xFFE9EBE5);

  // ============================================================
  // STATUS
  // ============================================================

  static const Color success = Color(0xFF719366);

  static const Color successBg = Color(0xFFEAF1E6);

  static const Color warning = Color(0xFFC69E59);

  static const Color warningBg = Color(0xFFF8F1E1);

  static const Color error = Color(0xFFC76A68);

  static const Color errorBg = Color(0xFFF8EAEA);

  static const Color info = Color(0xFF6689A0);

  static const Color infoBg = Color(0xFFEAF1F5);

  // ============================================================
  // NOTION / CATEGORY BACKGROUNDS
  // ============================================================

  static const Color notionBgGrey = Color(0xFFF1F2EF);

  static const Color notionBgBrown = Color(0xFFF4EFEC);

  static const Color notionBgOrange = Color(0xFFFAECDE);

  static const Color notionBgYellow = Color(0xFFFBF3DD);

  static const Color notionBgGreen = Color(0xFFEDF3E9);

  static const Color notionBgBlue = Color(0xFFE8F2F6);

  static const Color notionBgPurple = Color(0xFFF5F2F8);

  static const Color notionBgPink = Color(0xFFFAF1F5);

  static const Color notionBgRed = Color(0xFFFBECEC);

  // ============================================================
  // OVERLAY / SHADOW
  // ============================================================

  /// Overlay ringan
  static const Color overlay = Color(0x14000000);

  /// Shadow sangat soft
  static const Color shadow = Color(0x12000000);

  // ============================================================
  // NAVIGATION / SELECTION
  // ============================================================

  /// Soft sage background untuk menu yang sedang aktif
  static const Color selectedBackground = Color(0xFFE8EEDF);

  /// Border sangat subtle untuk menu aktif
  static const Color selectedBorder = Color(0xFFDCE4D1);

  /// Icon / text pada menu aktif
  static const Color selectedForeground = Color(0xFF627A43);
}
