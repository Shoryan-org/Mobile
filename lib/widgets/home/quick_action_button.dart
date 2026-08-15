import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.softPink,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primaryRed, size: 22),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 68,
            child: Text(
              label,
              style: AppTextStyles.metaText,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}