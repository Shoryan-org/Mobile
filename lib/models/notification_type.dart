import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

enum NotificationType {
  criticalRequest(
    icon: Icons.local_shipping,
    iconColor: AppColors.white,
    iconBackground: AppColors.primaryRed,
    cardBackground: AppColors.veryLightPink,
  ),
  requestAccepted(
    icon: Icons.check_circle_outline,
    iconColor: AppColors.primaryRed,
    iconBackground: AppColors.softPink,
    cardBackground: AppColors.white,
  ),
  eligibilityReminder(
    icon: Icons.event_available,
    iconColor: AppColors.primaryRed,
    iconBackground: AppColors.softPink,
    cardBackground: AppColors.white,
  ),
  requestFulfilled(
    icon: Icons.notifications_none,
    iconColor: AppColors.primaryRed,
    iconBackground: AppColors.softPink,
    cardBackground: AppColors.white,
  ),
  nearbyRequest(
    icon: Icons.location_on_outlined,
    iconColor: AppColors.primaryRed,
    iconBackground: AppColors.softPink,
    cardBackground: AppColors.white,
  );

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final Color cardBackground;

  const NotificationType({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.cardBackground,
  });
}