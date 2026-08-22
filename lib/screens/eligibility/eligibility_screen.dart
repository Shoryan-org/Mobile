import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_date_utils.dart';
import '../../data/repositories/donor_repository.dart';
import '../../data/repositories/mock_donor_repository.dart';
import '../../models/donor_profile.dart';
import '../../models/preparation_tip.dart';
import '../../widgets/eligibility/eligibility_info_tile.dart';
import '../../widgets/eligibility/eligibility_status_card.dart';
import '../../widgets/eligibility/preparation_tip_card.dart';

class EligibilityScreen extends StatefulWidget {
  final DonorRepository donorRepository;

  EligibilityScreen({
    super.key,
    DonorRepository? donorRepository,
  }) : donorRepository = donorRepository ?? MockDonorRepository();

  @override
  State<EligibilityScreen> createState() => _EligibilityScreenState();
}

class _EligibilityScreenState extends State<EligibilityScreen> {
  DonorProfile? _profile;

  final List<PreparationTip> _tips = [
    PreparationTip(
      icon: Icons.restaurant_outlined,
      title: 'Eat iron-rich food',
      description: 'Have a full meal 3 hours before donating.',
    ),
    PreparationTip(
      icon: Icons.water_drop_outlined,
      title: 'Hydrate well',
      description: 'Drink 500 ml of water before your appointment.',
    ),
    PreparationTip(
      icon: Icons.nightlight_outlined,
      title: 'Sleep 7+ hours',
      description: 'Avoid donating after a sleepless night.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final profile = await widget.donorRepository.getCurrentDonor();

    if (!mounted) return;

    setState(() {
      _profile = profile;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = _profile;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: const Text(
          'Eligibility',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 19,
          ),
        ),
      ),
      body: profile == null
          ? const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryRed,
        ),
      )
          : ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          const Text(
            'Whole blood · every 90 days',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),

          EligibilityStatusCard(profile: profile),

          const SizedBox(height: 14),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EligibilityInfoTile(
                icon: Icons.event_outlined,
                label: 'Last donation',
                value: AppDateUtils.fullDate(
                  profile.lastDonationDate,
                ),
                subtitle: profile.lastDonationLocation,
              ),
              const SizedBox(width: 10),
              EligibilityInfoTile(
                icon: Icons.event_available_outlined,
                label: 'Next eligible',
                value: profile.isEligibleNow
                    ? 'Today'
                    : AppDateUtils.shortDate(
                  profile.nextEligibleDate,
                ),
                pillText: profile.isEligibleNow ? 'Ready now' : null,
              ),
            ],
          ),

          const SizedBox(height: 22),

          const Text(
            'Preparation tips',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 12),

          ..._tips.map(
                (tip) => PreparationTipCard(tip: tip),
          ),
        ],
      ),
    );
  }
}