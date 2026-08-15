import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../common/icon_circle.dart';

class LivesSavedBanner extends StatelessWidget {
  final int livesSaved;
  final int unitsCovered;
  final VoidCallback? onHistoryTap;

  const LivesSavedBanner({
    super.key,
    required this.livesSaved,
    required this.unitsCovered,
    this.onHistoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.veryLightPink,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const IconCircle(
            icon: Icons.water_drop,
            background: AppColors.lightPink,
            iconColor: AppColors.primaryRed,
            size: 40,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$livesSaved lives saved this year',
                  style: AppTextStyles.cardTitle,
                ),
                const SizedBox(height: 2),
                Text(
                  'Your donations covered $unitsCovered units of whole blood.',
                  style: AppTextStyles.cardSubtitle,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: onHistoryTap,
            child: const Text('History'),
          ),
        ],
      ),
    );
  }
}