import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/donor_profile.dart';

/// Adapts to both eligibility states, not just the "eligible" mockup:
/// when the donor still has days left to recover, this shows "Not
/// eligible yet" and how many days remain instead.
class EligibilityStatusCard extends StatelessWidget {
  final DonorProfile profile;

  const EligibilityStatusCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final bool eligible = profile.isEligibleNow;
    final int daysLeft = DonorProfile.eligibilityWindowDays - profile.daysRecovered;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryRed, Color(0xFF6E0F0B)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'CURRENT STATUS',
                  style: TextStyle(
                    color: AppColors.softPink,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  eligible ? Icons.check : Icons.hourglass_top,
                  color: AppColors.white,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            eligible ? 'Eligible to donate' : 'Not eligible yet',
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            eligible
                ? 'Your 90-day recovery window is complete.'
                : '$daysLeft day${daysLeft == 1 ? '' : 's'} left until your 90-day recovery window is complete.',
            style: const TextStyle(color: AppColors.softPink, fontSize: 13),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: profile.daysRecovered / DonorProfile.eligibilityWindowDays,
              minHeight: 8,
              backgroundColor: AppColors.white.withOpacity(0.25),
              valueColor: const AlwaysStoppedAnimation(AppColors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${profile.daysRecovered} of ${DonorProfile.eligibilityWindowDays} days recovered',
            style: const TextStyle(color: AppColors.softPink, fontSize: 12),
          ),
        ],
      ),
    );
  }
}