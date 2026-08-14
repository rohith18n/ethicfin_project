import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Dark Theme Palette (GitHub Dim / Dark)
  static const Color darkBg = Color(0xFF0D1117);
  static const Color darkSurface = Color(0xFF161B22);
  static const Color darkCard = Color(0xFF21262D);
  static const Color darkCardHover = Color(0xFF30363D);
  static const Color darkBorder = Color(0xFF30363D);
  static const Color darkTextPrimary = Color(0xFFF0F6FC);
  static const Color darkTextSecondary = Color(0xFF8B949E);
  static const Color darkTextMuted = Color(0xFF6E7681);

  // Light Theme Palette
  static const Color lightBg = Color(0xFFF6F8FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardHover = Color(0xFFF3F4F6);
  static const Color lightBorder = Color(0xFFD0D7DE);
  static const Color lightTextPrimary = Color(0xFF1F2328);
  static const Color lightTextSecondary = Color(0xFF656D76);
  static const Color lightTextMuted = Color(0xFF8C959F);

  // Brand Accents
  static const Color githubPrimary = Color(0xFF238636);
  static const Color githubBlue = Color(0xFF2F81F7);
  static const Color githubPurple = Color(0xFFA371F7);
  static const Color githubOrange = Color(0xFFD29922);
  static const Color githubRed = Color(0xFFF85149);
  static const Color githubGreen = Color(0xFF3FB950);
  static const Color githubYellow = Color(0xFFE3B341);

  // Gradient accents
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2F81F7), Color(0xFFA371F7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF161B22), Color(0xFF0D1117)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
