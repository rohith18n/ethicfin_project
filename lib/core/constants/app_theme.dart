import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    final baseTextTheme = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.githubBlue,
        secondary: AppColors.githubPurple,
        surface: AppColors.darkSurface,
        error: AppColors.githubRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.darkTextPrimary,
        onError: Colors.white,
        outline: AppColors.darkBorder,
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          color: AppColors.darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        hintStyle: GoogleFonts.inter(
          color: AppColors.darkTextMuted,
          fontSize: 15,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.githubBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.githubRed, width: 1.2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.githubBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      textTheme: baseTextTheme.copyWith(
        titleLarge: GoogleFonts.inter(
          color: AppColors.darkTextPrimary,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        titleMedium: GoogleFonts.inter(
          color: AppColors.darkTextPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.inter(
          color: AppColors.darkTextPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: GoogleFonts.inter(
          color: AppColors.darkTextSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        labelSmall: GoogleFonts.inter(
          color: AppColors.darkTextMuted,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 1,
        space: 24,
      ),
    );
  }

  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.interTextTheme(ThemeData.light().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBg,
      colorScheme: const ColorScheme.light(
        primary: AppColors.githubBlue,
        secondary: AppColors.githubPurple,
        surface: AppColors.lightSurface,
        error: AppColors.githubRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.lightTextPrimary,
        onError: Colors.white,
        outline: AppColors.lightBorder,
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          color: AppColors.lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurface,
        hintStyle: GoogleFonts.inter(
          color: AppColors.lightTextMuted,
          fontSize: 15,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.githubBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.githubRed, width: 1.2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.githubBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      textTheme: baseTextTheme.copyWith(
        titleLarge: GoogleFonts.inter(
          color: AppColors.lightTextPrimary,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        titleMedium: GoogleFonts.inter(
          color: AppColors.lightTextPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.inter(
          color: AppColors.lightTextPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: GoogleFonts.inter(
          color: AppColors.lightTextSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        labelSmall: GoogleFonts.inter(
          color: AppColors.lightTextMuted,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorder,
        thickness: 1,
        space: 24,
      ),
    );
  }
}
