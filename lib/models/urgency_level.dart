import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// How urgently a request needs a donor. Each level carries its own
/// display metadata (label + colors)
enum UrgencyLevel {
  critical(
    'CRITICAL',
    AppColors.critical,
    AppColors.criticalBackground,
    formLabel: 'Emergency',
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
    'ROUTINE',
    AppColors.routine,
    AppColors.routineBackground,
    formLabel: 'Planned',
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
}
