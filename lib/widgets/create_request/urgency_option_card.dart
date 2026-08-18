import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/urgency_level.dart';

class UrgencyOptionCard extends StatelessWidget {
  final UrgencyLevel level;
  final bool isSelected;
  final VoidCallback onTap;

  const UrgencyOptionCard({
    super.key,
    required this.level,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color fg = isSelected ? AppColors.white : AppColors.textPrimary;
    final Color subFg = isSelected ? AppColors.softPink : AppColors.textSecondary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryRed : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryRed : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.white.withOpacity(0.18)
                    : AppColors.softPink,
                shape: BoxShape.circle,
              ),
              child: Icon(
                level.formIcon,
                size: 16,
                color: isSelected ? AppColors.white : AppColors.primaryRed,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    level.formLabel,
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15, color: fg),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    level.formDescription,
                    style: TextStyle(fontSize: 12, color: subFg),
                  ),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.white : AppColors.border,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}