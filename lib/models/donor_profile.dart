import 'blood_type.dart';

class DonorProfile {
  static const int eligibilityWindowDays = 90;

  final String name;
  final String city;
  final BloodType bloodType;
  final DateTime lastDonationDate;
  final String lastDonationLocation;

  final int livesSavedThisYear;
  final int unitsCoveredThisYear;

  final int totalDonations;
  final int totalLivesSaved;

  final bool isRequester;
  final bool isVerified;
  final int unreadNotificationsCount;

  const DonorProfile({
    required this.name,
    required this.city,
    required this.bloodType,
    required this.lastDonationDate,
    required this.lastDonationLocation,
    required this.livesSavedThisYear,
    required this.unitsCoveredThisYear,
    required this.totalDonations,
    required this.totalLivesSaved,
    this.isRequester = false,
    this.isVerified = false,
    this.unreadNotificationsCount = 0,
  });

  int get daysSinceLastDonation =>
      DateTime.now().difference(lastDonationDate).inDays;


  /// more than "90 of 90 days" even if the donor is overdue.
  int get daysRecovered =>
      daysSinceLastDonation.clamp(0, eligibilityWindowDays);

  bool get isEligibleNow => daysSinceLastDonation >= eligibilityWindowDays;

  DateTime get nextEligibleDate =>
      lastDonationDate.add(const Duration(days: eligibilityWindowDays));

  /// used by the Profile avatar circle.
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts[1][0]).toUpperCase();
  }
}