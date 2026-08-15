import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// How urgently a request needs a donor. Each level carries its own
/// display metadata (label + colors)
enum UrgencyLevel {
  critical('CRITICAL', AppColors.critical, AppColors.criticalBackground),
  urgent('URGENT', AppColors.urgent, AppColors.urgentBackground),
  routine('ROUTINE', AppColors.routine, AppColors.routineBackground);

  final String label;
  final Color foreground;
  final Color background;

  const UrgencyLevel(this.label, this.foreground, this.background);
}