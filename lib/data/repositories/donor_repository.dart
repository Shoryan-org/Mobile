import '../../models/donor_profile.dart';

/// Abstract data source for the signed-in donor's own profile.
abstract class DonorRepository {
  Future<DonorProfile> getCurrentDonor();
}
