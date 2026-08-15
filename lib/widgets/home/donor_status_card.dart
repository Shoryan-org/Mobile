import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_date_utils.dart';
import '../../models/donor_profile.dart';
import '../requests/blood_type_avatar.dart';

class DonorStatusCard extends StatelessWidget {
  final DonorProfile profile;
  final VoidCallback? onViewEligibility;

  const DonorStatusCard({
    super.key,
    required this.profile,
    this.onViewEligibility,
  });

  @override
  Widget build(BuildContext context) {
    final lastDonation = AppDateUtils.shortDate(profile.lastDonationDate);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BloodTypeAvatar(bloodType: profile.bloodType, size: 48),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      profile.bloodType.isUniversalDonor
                          ? 'Universal donor'
                          : 'Donor',
                      style: AppTextStyles.cardTitle,
                    ),
                    const SizedBox(width: 8),
                    if (profile.isEligibleNow) const _EligiblePill(),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  profile.isEligibleNow
                      ? 'Last donation $lastDonation · you can donate today'
                      : 'Last donation $lastDonation',
                  style: AppTextStyles.cardSubtitle,
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: onViewEligibility,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View eligibility',
                        style: TextStyle(
                          color: AppColors.primaryRed,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      Icon(Icons.chevron_right,
                          size: 16, color: AppColors.primaryRed),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EligiblePill extends StatelessWidget {
  const _EligiblePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.softPink,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Eligible',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryRed,
        ),
      ),
    );
  }
}
