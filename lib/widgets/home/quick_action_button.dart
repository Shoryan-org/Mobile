import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../common/icon_circle.dart';

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
          IconCircle(
            icon: icon,
            background: AppColors.softPink,
            iconColor: AppColors.primaryRed,
            size: 50,
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