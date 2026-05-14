import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Display / hero
  static TextStyle get displayLarge => GoogleFonts.orbitron(
        fontSize: 48,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
        color: AppColors.textPrimary,
        height: 1.05,
      );

  static TextStyle get displayMedium => GoogleFonts.orbitron(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
        color: AppColors.textPrimary,
      );

  static TextStyle get displaySmall => GoogleFonts.orbitron(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
        color: AppColors.textPrimary,
      );

  // Headlines
  static TextStyle get headlineLarge => GoogleFonts.rajdhani(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: 0.5,
      );

  static TextStyle get headlineMedium => GoogleFonts.rajdhani(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineSmall => GoogleFonts.rajdhani(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  // Body
  static TextStyle get bodyLarge => GoogleFonts.rajdhani(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyMedium => GoogleFonts.rajdhani(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );

  static TextStyle get bodySmall => GoogleFonts.rajdhani(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
      );

  // Button
  static TextStyle get button => GoogleFonts.rajdhani(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: AppColors.textPrimary,
      );

  static TextStyle get buttonLarge => GoogleFonts.orbitron(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.5,
        color: AppColors.textPrimary,
      );

  // Numeric / HUD
  static TextStyle get hud => GoogleFonts.orbitron(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: 1.2,
      );

  static TextStyle get hudLarge => GoogleFonts.orbitron(
        fontSize: 40,
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
        letterSpacing: 2,
      );

  static TextStyle get speedometer => GoogleFonts.orbitron(
        fontSize: 56,
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
        letterSpacing: 2,
        height: 1.0,
      );

  static TextStyle get caption => GoogleFonts.rajdhani(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
        color: AppColors.textMuted,
      );
}
