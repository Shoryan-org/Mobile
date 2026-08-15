import '../../models/blood_type.dart';
import '../../models/donor_profile.dart';
import 'donor_repository.dart';

class MockDonorRepository implements DonorRepository {
  @override
  Future<DonorProfile> getCurrentDonor() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return DonorProfile(
      name: 'Mariam Hassan',
      city: 'Nasr City, Cairo',
      bloodType: BloodType.oNegative,
      lastDonationDate: DateTime(2026, 5, 12),
      lastDonationLocation: 'Nasr City blood bank',
      livesSavedThisYear: 3,
      unitsCoveredThisYear: 4,
      totalDonations: 4,
      totalLivesSaved: 12,
      isRequester: true,
      isVerified: true,
      unreadNotificationsCount: 2,
    );
  }
}