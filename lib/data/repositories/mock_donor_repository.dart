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
      lastDonationDate: DateTime(DateTime.now().year, 5, 12),
      livesSavedThisYear: 3,
      unitsCoveredThisYear: 4,
    );
  }
}