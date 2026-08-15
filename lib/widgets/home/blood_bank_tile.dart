import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/blood_bank.dart';
import '../common/icon_circle.dart';

class BloodBankTile extends StatelessWidget {
  final BloodBank bank;
  final VoidCallback? onDirectionsTap;

  const BloodBankTile({super.key, required this.bank, this.onDirectionsTap});

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
          const IconCircle(
            icon: Icons.location_on_outlined,
            background: AppColors.softPink,
            iconColor: AppColors.primaryRed,
            size: 38,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bank.name, style: AppTextStyles.cardTitle),
                const SizedBox(height: 2),
                Text(
                  '${bank.type} · ${bank.distanceKm} km · ${bank.statusLabel}',
                  style: AppTextStyles.cardSubtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onDirectionsTap,
            borderRadius: BorderRadius.circular(20),
            child: const IconCircle(
              icon: Icons.navigation_outlined,
              background: AppColors.veryLightPink,
              iconColor: AppColors.primaryRed,
              size: 34,
            ),
          ),
        ],
      ),
    );
  }
}