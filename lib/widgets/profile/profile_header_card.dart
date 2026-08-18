import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/donor_profile.dart';
import '../common/tag_pill.dart';
import '../requests/blood_type_avatar.dart';

class ProfileHeaderCard extends StatelessWidget {
  final DonorProfile profile;

  const ProfileHeaderCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.primaryRed,
              shape: BoxShape.circle,
            ),
            child: Text(
              profile.initials,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(profile.name, style: AppTextStyles.screenSubtitle.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                )),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 13, color: AppColors.textSecondary),
                    const SizedBox(width: 3),
                    Text(profile.city, style: AppTextStyles.cardSubtitle),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    const TagPill(
                      label: 'Donor',
                      background: AppColors.primaryRed,
                      foreground: AppColors.white,
                    ),
                    if (profile.isRequester)
                      const TagPill(
                        label: 'Requester',
                        background: AppColors.lightPink,
                        foreground: AppColors.primaryRed,
                      ),
                    if (profile.isVerified)
                      const TagPill(
                        label: 'Verified',
                        background: AppColors.routineBackground,
                        foreground: AppColors.routine,
                        icon: Icons.check_circle,
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          BloodTypeAvatar(bloodType: profile.bloodType, filled: false, size: 48),
        ],
      ),
    );
  }
}