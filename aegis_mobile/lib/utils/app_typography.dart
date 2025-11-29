import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aegis_mobile/utils/app_color.dart';

class AppTypography {
  AppTypography._();

  // Font Family
  static String get fontFamily => GoogleFonts.plusJakartaSans().fontFamily!;

  // Display Styles
  static TextStyle displayLarge = GoogleFonts.plusJakartaSans(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.12,
    color: AppColor.textPrimary,
  );

  static TextStyle displayMedium = GoogleFonts.plusJakartaSans(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.16,
    color: AppColor.textPrimary,
  );

  static TextStyle displaySmall = GoogleFonts.plusJakartaSans(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.22,
    color: AppColor.textPrimary,
  );

  // Headline Styles
  static TextStyle headlineLarge = GoogleFonts.plusJakartaSans(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.25,
    color: AppColor.textPrimary,
  );

  static TextStyle headlineMedium = GoogleFonts.plusJakartaSans(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.29,
    color: AppColor.textPrimary,
  );

  static TextStyle headlineSmall = GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.33,
    color: AppColor.textPrimary,
  );

  // Title Styles
  static TextStyle titleLarge = GoogleFonts.plusJakartaSans(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.27,
    color: AppColor.textPrimary,
  );

  static TextStyle titleMedium = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.5,
    color: AppColor.textPrimary,
  );

  static TextStyle titleSmall = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
    color: AppColor.textPrimary,
  );

  // Body Styles
  static TextStyle bodyLarge = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.5,
    color: AppColor.textPrimary,
  );

  static TextStyle bodyMedium = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
    color: AppColor.textPrimary,
  );

  static TextStyle bodySmall = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    color: AppColor.textSecondary,
  );

  // Label Styles
  static TextStyle labelLarge = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    color: AppColor.textPrimary,
  );

  static TextStyle labelMedium = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33,
    color: AppColor.textPrimary,
  );

  static TextStyle labelSmall = GoogleFonts.plusJakartaSans(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
    color: AppColor.textSecondary,
  );

  // Button Text
  static TextStyle buttonLarge = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.5,
    color: AppColor.white,
  );

  static TextStyle buttonMedium = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.43,
    color: AppColor.white,
  );

  static TextStyle buttonSmall = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.33,
    color: AppColor.white,
  );

  // Caption
  static TextStyle caption = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    color: AppColor.textTertiary,
  );

  // Overline
  static TextStyle overline = GoogleFonts.plusJakartaSans(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
    height: 1.6,
    color: AppColor.textSecondary,
  );

  // TextTheme for MaterialApp
  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      );

  // Dark TextTheme
  static TextTheme get textThemeDark => TextTheme(
        displayLarge: displayLarge.copyWith(color: AppColor.textPrimaryDark),
        displayMedium: displayMedium.copyWith(color: AppColor.textPrimaryDark),
        displaySmall: displaySmall.copyWith(color: AppColor.textPrimaryDark),
        headlineLarge: headlineLarge.copyWith(color: AppColor.textPrimaryDark),
        headlineMedium:
            headlineMedium.copyWith(color: AppColor.textPrimaryDark),
        headlineSmall: headlineSmall.copyWith(color: AppColor.textPrimaryDark),
        titleLarge: titleLarge.copyWith(color: AppColor.textPrimaryDark),
        titleMedium: titleMedium.copyWith(color: AppColor.textPrimaryDark),
        titleSmall: titleSmall.copyWith(color: AppColor.textPrimaryDark),
        bodyLarge: bodyLarge.copyWith(color: AppColor.textPrimaryDark),
        bodyMedium: bodyMedium.copyWith(color: AppColor.textPrimaryDark),
        bodySmall: bodySmall.copyWith(color: AppColor.textSecondaryDark),
        labelLarge: labelLarge.copyWith(color: AppColor.textPrimaryDark),
        labelMedium: labelMedium.copyWith(color: AppColor.textPrimaryDark),
        labelSmall: labelSmall.copyWith(color: AppColor.textSecondaryDark),
      );
}
