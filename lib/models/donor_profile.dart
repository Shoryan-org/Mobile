import 'blood_type.dart';

class DonorProfile {
  final String name;
  final String city;
  final BloodType bloodType;
  final DateTime lastDonationDate;
  final int livesSavedThisYear;
  final int unitsCoveredThisYear;

  const DonorProfile({
    required this.name,
    required this.city,
    required this.bloodType,
    required this.lastDonationDate,
    required this.livesSavedThisYear,
    required this.unitsCoveredThisYear,
  });

  /// eligible again 3 months after their last donation.
  DateTime get nextEligibleDate => DateTime(
    lastDonationDate.year,
    lastDonationDate.month + 3,
    lastDonationDate.day,
  );

  bool get isEligibleNow => !DateTime.now().isBefore(nextEligibleDate);
}