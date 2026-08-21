import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoryan/features/auth/domain/repositories/auth_repository.dart';
import 'package:shoryan/features/auth/presentation/cubit/auth_cubit.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/donor_profile_update.dart';
import '../../widgets/common/placeholder_screen.dart';
import '../../widgets/common/stat_card.dart';
import '../../widgets/profile/profile_header_card.dart';
import '../../widgets/profile/profile_list_tile.dart';
import '../notfications/notifications_screen.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DonorProfile? _profile;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final raw = await context.read<AuthRepository>().getCurrentUser();
      if (!mounted) return;
      setState(() => _profile = DonorProfile.fromJson(raw));
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: AppColors.primaryRed, size: 36),
                const SizedBox(height: 12),
                Text(
                  'Couldn\'t load your profile.\n$_error',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.cardSubtitle,
                ),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: _load, child: const Text('Retry')),
              ],
            ),
          ),
        ),
      );
    }

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
      body: RefreshIndicator(
        color: AppColors.primaryRed,
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          children: [
            ProfileHeaderCard(profile: profile),
            const SizedBox(height: 14),
            Row(
              children: [
                StatCard(value: '${profile.totalDonations}', label: 'Donations'),
                const SizedBox(width: 10),
                StatCard(value: '${profile.totalLivesSaved}', label: 'Lives'),
                const SizedBox(width: 10),
                StatCard(
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
                      MaterialPageRoute(
                        builder: (_) => const PlaceholderScreen(
                          title: 'Eligibility',
                          subtitle: 'Coming soon — not merged into this branch yet.',
                        ),
                      ),
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
                          subtitle: 'Coming soon — no endpoint for this yet.',
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
                      MaterialPageRoute(builder: (_) => NotificationsScreen()),
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.border),
                  ProfileListTile(
                    icon: Icons.location_on_outlined,
                    title: 'Saved centers',
                    subtitle: 'Nearby blood banks',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const PlaceholderScreen(
                          title: 'Saved centers',
                          subtitle: 'Coming soon — not merged into this branch yet.',
                        ),
                      ),
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
                // MainNavigationScreen already listens for
                // AuthUnauthenticated and redirects to SignInScreen —
                // this screen just triggers it, no manual navigation needed.
                onTap: () => context.read<AuthCubit>().logout(),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text('Shoryan · v1.0.0', style: AppTextStyles.metaText),
            ),
          ],
        ),
      ),
    );
  }
}
