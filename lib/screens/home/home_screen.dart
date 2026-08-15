import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/repositories/blood_bank_repository.dart';
import '../../data/repositories/blood_request_repository.dart';
import '../../data/repositories/donor_repository.dart';
import '../../data/repositories/mock_blood_bank_repository.dart';
import '../../data/repositories/mock_blood_request_repository.dart';
import '../../data/repositories/mock_donor_repository.dart';
import '../../models/blood_bank.dart';
import '../../models/blood_request.dart';
import '../../models/donor_profile.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/home/blood_bank_tile.dart';
import '../../widgets/home/donor_status_card.dart';
import '../../widgets/home/lives_saved_banner.dart';
import '../../widgets/home/quick_action_button.dart';
import '../../widgets/requests/request_card.dart';


class HomeScreen extends StatefulWidget {
  final BloodRequestRepository requestRepository;
  final DonorRepository donorRepository;
  final BloodBankRepository bloodBankRepository;

  HomeScreen({
    super.key,
    BloodRequestRepository? requestRepository,
    DonorRepository? donorRepository,
    BloodBankRepository? bloodBankRepository,
  })  : requestRepository = requestRepository ?? MockBloodRequestRepository(),
        donorRepository = donorRepository ?? MockDonorRepository(),
        bloodBankRepository = bloodBankRepository ?? MockBloodBankRepository();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DonorProfile? _donor;
  List<BloodRequest> _urgentRequests = [];
  List<BloodBank> _banks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final results = await Future.wait([
      widget.donorRepository.getCurrentDonor(),
      widget.requestRepository.getUrgentRequests(),
      widget.bloodBankRepository.getNearbyBanks(),
    ]);

    if (!mounted) return;
    setState(() {
      _donor = results[0] as DonorProfile;
      _urgentRequests = results[1] as List<BloodRequest>;
      _banks = results[2] as List<BloodBank>;
      _isLoading = false;
    });
  }

  void _dismissRequest(String id) {
    setState(() => _urgentRequests.removeWhere((r) => r.id == id));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _donor == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryRed),
        ),
      );
    }

    final donor = _donor!;

    return Scaffold(
      body: RefreshIndicator(
        color: AppColors.primaryRed,
        onRefresh: _loadData,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _HomeHeader(donor: donor)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  DonorStatusCard(profile: donor),
                  const SizedBox(height: 18),
                  const _QuickActionsRow(),
                  const SizedBox(height: 22),
                  SectionHeader(
                    title: 'Urgent near you',
                    actionLabel: 'See all',
                    onActionTap: () {},
                  ),
                  const SizedBox(height: 12),
                  if (_urgentRequests.isEmpty)
                    const Text(
                      'No urgent requests near you right now.',
                      style: AppTextStyles.cardSubtitle,
                    )
                  else
                    ..._urgentRequests.map(
                          (request) => RequestCard(
                        request: request,
                        onAccept: () {},
                        onDismiss: () => _dismissRequest(request.id),
                      ),
                    ),
                  const SizedBox(height: 6),
                  LivesSavedBanner(
                    livesSaved: donor.livesSavedThisYear,
                    unitsCovered: donor.unitsCoveredThisYear,
                    onHistoryTap: () {},
                  ),
                  const SizedBox(height: 22),
                  SectionHeader(
                    title: 'Nearby blood banks',
                    actionLabel: 'Map',
                    onActionTap: () {},
                  ),
                  const SizedBox(height: 12),
                  ..._banks.map((bank) => BloodBankTile(bank: bank)),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final DonorProfile donor;

  const _HomeHeader({required this.donor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primaryRed,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'GOOD EVENING',
                      style: TextStyle(
                        color: AppColors.softPink,
                        fontSize: 11,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      donor.name,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 14, color: AppColors.softPink),
                        const SizedBox(width: 4),
                        Text(
                          donor.city,
                          style: const TextStyle(
                              color: AppColors.softPink, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.notifications_outlined,
                    color: AppColors.white, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        QuickActionButton(icon: Icons.add, label: 'New request', onTap: () {}),
        QuickActionButton(icon: Icons.bolt, label: 'Urgent', onTap: () {}),
        QuickActionButton(
            icon: Icons.people_outline, label: 'Find donors', onTap: () {}),
        QuickActionButton(
            icon: Icons.event_available_outlined,
            label: 'Eligibility',
            onTap: () {}),
      ],
    );
  }
}