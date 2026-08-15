import 'package:flutter/material.dart';

/// color palette for the Shoryan app.

class AppColors {
  AppColors._();

  static const Color primaryRed = Color(0xFF921510);
  static const Color softPink = Color(0xFFFFE9E6);
  static const Color lightPink = Color(0xFFFFD4D1);
  static const Color veryLightPink = Color(0xFFFFF3F1);
  static const Color offWhite = Color(0xFFFAFAFA);
  static const Color white = Color(0xFFFFFFFF);

  // ---- Functional colors for status badges ----
  static const Color critical = primaryRed;
  static const Color criticalBackground = lightPink;
  static const Color urgent = Color(0xFFB9622A);
  static const Color urgentBackground = Color(0xFFFFE6D2);
  static const Color routine = Color(0xFF6B6B6B);
  static const Color routineBackground = Color(0xFFEDEDED);

  // ---- Text ----
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF7A7A7A);
  static const Color textOnPrimary = white;

  // ---- Structural ----
  static const Color border = Color(0xFFF0E4E3);
  static const Color progressTrack = lightPink;
}
