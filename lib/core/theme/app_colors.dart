import 'package:flutter/material.dart';

/// Cyber/Neon palette tuned for racing-game aesthetic.
class AppColors {
  AppColors._();

  // Backgrounds (deep night)
  static const Color bgDarkest = Color(0xFF05060B);
  static const Color bgDark = Color(0xFF0A0E1A);
  static const Color bgMid = Color(0xFF121829);
  static const Color bgLight = Color(0xFF1A2138);
  static const Color surface = Color(0xFF1E2640);
  static const Color surfaceElevated = Color(0xFF26304F);

  // Neon accents
  static const Color neonPink = Color(0xFFFF2A7F);
  static const Color neonPurple = Color(0xFF9C27FF);
  static const Color neonBlue = Color(0xFF00E0FF);
  static const Color neonCyan = Color(0xFF00FFD1);
  static const Color neonGreen = Color(0xFF22FF88);
  static const Color neonYellow = Color(0xFFFFE600);
  static const Color neonOrange = Color(0xFFFF6A00);
  static const Color neonRed = Color(0xFFFF1744);

  // Primary brand
  static const Color primary = neonPink;
  static const Color secondary = neonBlue;
  static const Color accent = neonYellow;

  // Status
  static const Color success = neonGreen;
  static const Color warning = Color(0xFFFFB300);
  static const Color danger = neonRed;
  static const Color info = neonBlue;

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB7BED4);
  static const Color textMuted = Color(0xFF7B829A);
  static const Color textDisabled = Color(0xFF4C5266);

  // Currency
  static const Color coinGold = Color(0xFFFFC940);
  static const Color gemPurple = Color(0xFFB14CFF);
  static const Color fuelOrange = Color(0xFFFF8A2E);
  static const Color eventToken = Color(0xFF00E0FF);

  // Rarity colors
  static const Color rarityCommon = Color(0xFF9CA3AF);
  static const Color rarityRare = Color(0xFF3B82F6);
  static const Color rarityEpic = Color(0xFFA855F7);
  static const Color rarityLegendary = Color(0xFFF59E0B);
  static const Color rarityMythic = Color(0xFFEF4444);

  // Gradients
  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bgDark, bgDarkest, Color(0xFF0F0822)],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [neonPink, neonPurple],
  );

  static const LinearGradient nitroGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [neonOrange, neonYellow, neonRed],
  );

  static const LinearGradient cyberGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [neonBlue, neonPurple, neonPink],
  );

  static const LinearGradient coinGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFD86A), Color(0xFFFFAA00)],
  );
}
