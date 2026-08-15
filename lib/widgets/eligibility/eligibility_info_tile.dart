import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../common/tag_pill.dart';

class EligibilityInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;
  final String? pillText;

  const EligibilityInfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.subtitle,
    this.pillText,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.softPink,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 15, color: AppColors.primaryRed),
            ),
            const SizedBox(height: 10),
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle!,
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
            if (pillText != null) ...[
              const SizedBox(height: 8),
              TagPill(
                label: pillText!,
                background: AppColors.softPink,
                foreground: AppColors.primaryRed,
              ),
            ],
          ],
        ),
      ),
    );
  }
}