import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A small bordered stat card: a bold number/value on top, a caps-label
/// underneath. Used for Profile's Donations / Lives / Eligible row.
class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final bool highlight;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: highlight ? AppColors.primaryRed : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}