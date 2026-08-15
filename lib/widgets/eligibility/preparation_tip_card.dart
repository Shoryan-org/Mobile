import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/preparation_tip.dart';
import '../common/icon_circle.dart';

class PreparationTipCard extends StatelessWidget {
  final PreparationTip tip;

  const PreparationTipCard({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          IconCircle(
            icon: tip.icon,
            background: AppColors.softPink,
            iconColor: AppColors.primaryRed,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tip.title, style: AppTextStyles.cardTitle),
                const SizedBox(height: 2),
                Text(tip.description, style: AppTextStyles.cardSubtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}