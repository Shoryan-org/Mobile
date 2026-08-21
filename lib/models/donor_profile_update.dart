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

  factory DonorProfile.fromJson(Map<String, dynamic> json) {
    // Some endpoints wrap the payload in a `data` key, some don't.
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    final name = data['name'] as String? ?? '';


    // address.address_text. Confirm against a real /me response.
    String city = '';
    final address = data['address'];
    if (address is Map<String, dynamic>) {
      city = address['address_text'] as String? ?? '';
    } else if (address is String) {
      city = address;
    }

    // Best guess at blood type label (e.g. "O-"). Falls back to O+ if
    // missing or in a format BloodType.fromLabel doesn't recognize —
    // TODO: confirm the real format with the backend team.
    BloodType bloodType = BloodType.oPositive;
    final rawBloodType = data['blood_type']?.toString();
    if (rawBloodType != null && rawBloodType.isNotEmpty) {
      try {
        bloodType = BloodType.fromLabel(rawBloodType);
      } catch (_) {
        // the Profile screen over a display detail.
      }
    }

    // Mirrors the same role-parsing logic AuthCubit already uses, so
    // "isRequester" agrees with what the rest of the app decided.
    bool isRequester = false;
    if (data['roles'] is List) {
      isRequester = (data['roles'] as List)
          .map((r) => r.toString().toLowerCase())
          .contains('requester');
    }
    if (data['is_requester'] is bool) {
      isRequester = data['is_requester'] as bool;
    }

    return DonorProfile(
      name: name,
      city: city,
      bloodType: bloodType,
      // "long ago" (so the eligibility card shows "eligible" rather
      // than crashing) until a donor-stats endpoint exists.
      lastDonationDate: DateTime.now().subtract(const Duration(days: 9999)),
      lastDonationLocation: '',
      livesSavedThisYear: 0,
      unitsCoveredThisYear: 0,
      totalDonations: 0,
      totalLivesSaved: 0,
      isRequester: isRequester,
      isVerified: false, // TODO: no backend field yet
      unreadNotificationsCount: 0, // TODO: wire once a notifications-count endpoint exists
    );
  }
}