import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// How urgently a request needs a donor. Each level carries its own
/// display metadata (label + colors).
///
/// Backend values: EMERGENCY, CRITICAL, URGENT, NORMAL
enum UrgencyLevel {
  emergency(
    'EMERGENCY',
    AppColors.critical,
    AppColors.criticalBackground,
    formLabel: 'EMERGENCY',
    formDescription: 'Life-threatening – needed immediately',
    formIcon: Icons.emergency,
  ),
  critical(
    'CRITICAL',
    AppColors.critical,
    AppColors.criticalBackground,
    formLabel: 'CRITICAL',
    formDescription: 'Needed within hours',
    formIcon: Icons.wb_sunny,
  ),
  urgent(
    'URGENT',
    AppColors.urgent,
    AppColors.urgentBackground,
    formLabel: 'Urgent',
    formDescription: 'Needed within 24 hours',
    formIcon: Icons.wb_sunny,
  ),
  routine(
    'NORMAL',
    AppColors.routine,
    AppColors.routineBackground,
    formLabel: 'PLANNED',
    formDescription: 'Scheduled procedure',
    formIcon: Icons.wb_sunny,
  );

  final String label;
  final Color foreground;
  final Color background;

  final String formLabel;
  final String formDescription;
  final IconData formIcon;

  const UrgencyLevel(
      this.label,
      this.foreground,
      this.background, {
        required this.formLabel,
        required this.formDescription,
        required this.formIcon,
      });

  /// Parses a backend urgency string (case-insensitive) to the enum value.
  static UrgencyLevel fromBackend(String value) {
    final upper = value.toUpperCase();
    return UrgencyLevel.values.firstWhere(
      (u) => u.label == upper,
      orElse: () => UrgencyLevel.routine,
    );
  }
}
