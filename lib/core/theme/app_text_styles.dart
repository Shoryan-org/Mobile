import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Central text-style catalogue. Same idea as [AppColors]
class AppTextStyles {
  AppTextStyles._();


  static const String? fontFamily = null;

  static const TextStyle screenTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle screenSubtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    color: AppColors.textSecondary,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle cardSubtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  static const TextStyle metaText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    color: AppColors.textSecondary,
  );

  static const TextStyle badgeText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle navLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );
}