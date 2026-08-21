class SmartMatchingResponse {
  final String message;
  final SmartMatchingData data;

  SmartMatchingResponse({
    required this.message,
    required this.data,
  });

  factory SmartMatchingResponse.fromJson(Map<String, dynamic> json) {
    return SmartMatchingResponse(
      message: json['message'] ?? '',
      data: SmartMatchingData.fromJson(json['data'] ?? {}),
    );
  }
}

class SmartMatchingData {
  final List<AvailableDonor> availableUsers;
  final List<String> availableIds;
  final SmartMatchingSummary summary;

  SmartMatchingData({
    required this.availableUsers,
    required this.availableIds,
    required this.summary,
  });

  factory SmartMatchingData.fromJson(Map<String, dynamic> json) {
    return SmartMatchingData(
      availableUsers: (json['available_users'] as List?)
              ?.map((e) => AvailableDonor.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      availableIds: (json['available_ids'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      summary: SmartMatchingSummary.fromJson(json['summary'] ?? {}),
    );
  }
}

class AvailableDonor {
  final DonorUser user;
  final bool available;
  final double probability;

  AvailableDonor({
    required this.user,
    required this.available,
    required this.probability,
  });

  factory AvailableDonor.fromJson(Map<String, dynamic> json) {
    return AvailableDonor(
      user: DonorUser.fromJson(json['user'] ?? {}),
      available: json['available'] ?? false,
      probability: (json['probability'] ?? 0.0).toDouble(),
    );
  }
}

class DonorUser {
  final String userId;
  final int age;
  final int totalDonations;
  final double weightKg;
  final double hemoglobinGDL;
  final String gender;
  final String bloodGroup;
  final String city;
  final String state;
  final String donationCenter;
  final String country;

  DonorUser({
    required this.userId,
    required this.age,
    required this.totalDonations,
    required this.weightKg,
    required this.hemoglobinGDL,
    required this.gender,
    required this.bloodGroup,
    required this.city,
    required this.state,
    required this.donationCenter,
    required this.country,
  });

  factory DonorUser.fromJson(Map<String, dynamic> json) {
    return DonorUser(
      userId: json['user_id']?.toString() ?? '',
      age: json['age'] ?? 0,
      totalDonations: json['total_donations'] ?? 0,
      weightKg: (json['weight_kg'] ?? 0.0).toDouble(),
      hemoglobinGDL: (json['hemoglobin_g_dL'] ?? 0.0).toDouble(),
      gender: json['gender'] ?? '',
      bloodGroup: json['blood_group'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      donationCenter: json['donation_center'] ?? '',
      country: json['country'] ?? '',
    );
  }
}

class SmartMatchingSummary {
  final int totalChecked;
  final int availableCount;
  final int unavailableCount;

  SmartMatchingSummary({
    required this.totalChecked,
    required this.availableCount,
    required this.unavailableCount,
  });

  factory SmartMatchingSummary.fromJson(Map<String, dynamic> json) {
    return SmartMatchingSummary(
      totalChecked: json['total_checked'] ?? 0,
      availableCount: json['available_count'] ?? 0,
      unavailableCount: json['unavailable_count'] ?? 0,
    );
  }
}
