import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/repositories/donor_repository.dart';
import '../../data/repositories/mock_donor_repository.dart';
import '../../models/donor_profile.dart';
import '../../widgets/common/placeholder_screen.dart';
import '../../widgets/profile/profile_header_card.dart';
import '../../widgets/profile/profile_list_tile.dart';
import '../../widgets/profile/profile_stat_card.dart';
import '../eligibility/eligibility_screen.dart';
import '../notifications/notifications_screen.dart';
import '../saved_centers/saved_centers_screen.dart';

class ProfileScreen extends StatefulWidget {
  final DonorRepository repository;

  ProfileScreen({super.key, DonorRepository? repository})
      : repository = repository ?? MockDonorRepository();

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DonorProfile? _profile;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final profile = await widget.repository.getCurrentDonor();
    if (!mounted) return;
    setState(() => _profile = profile);
  }

  @override
  Widget build(BuildContext context) {
    final profile = _profile;
    if (profile == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryRed),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 20,
        title: const Text('Profile', style: AppTextStyles.screenTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(Icons.edit_outlined,
                    size: 18, color: AppColors.textPrimary),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          ProfileHeaderCard(profile: profile),
          const SizedBox(height: 14),
          Row(
            children: [
              ProfileStatCard(value: '${profile.totalDonations}', label: 'Donations'),
              const SizedBox(width: 10),
              ProfileStatCard(value: '${profile.totalLivesSaved}', label: 'Lives'),
              const SizedBox(width: 10),
              ProfileStatCard(
                value: profile.isEligibleNow ? 'Today' : 'Soon',
                label: 'Eligible',
                highlight: true,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                ProfileListTile(
                  icon: Icons.water_drop_outlined,
                  title: 'Eligibility status',
                  subtitle: profile.isEligibleNow ? 'Eligible today' : 'Recovering',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => EligibilityScreen(donorRepository: widget.repository)),
                  ),
                ),
                const Divider(height: 1, color: AppColors.border),
                ProfileListTile(
                  icon: Icons.history,
                  title: 'Donation history',
                  subtitle: '${profile.totalDonations} donations',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PlaceholderScreen(
                        title: 'Donation history',
                        subtitle: 'Coming soon — no mockup for this screen yet.',
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1, color: AppColors.border),
                ProfileListTile(
                  icon: Icons.notifications_none,
                  title: 'Notifications',
                  subtitle: profile.unreadNotificationsCount > 0
                      ? '${profile.unreadNotificationsCount} unread'
                      : 'All caught up',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                  ),
                ),
                const Divider(height: 1, color: AppColors.border),
                ProfileListTile(
                  icon: Icons.location_on_outlined,
                  title: 'Saved centers',
                  subtitle: 'Nearby blood banks',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SavedCentersScreen()),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ProfileListTile(
              icon: Icons.settings_outlined,
              title: 'Settings & privacy',
              subtitle: '',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const PlaceholderScreen(
                    title: 'Settings & privacy',
                    subtitle: 'Coming soon — no mockup for this screen yet.',
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ProfileListTile(
              icon: Icons.logout,
              title: 'Log out',
              subtitle: '',
              showChevron: false,
              titleColor: AppColors.primaryRed,
              onTap: () {},
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text('Shoryan · v1.0.0', style: AppTextStyles.metaText),
          ),
        ],
      ),
    );
  }
}