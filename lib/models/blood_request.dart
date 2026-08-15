import 'blood_type.dart';
import 'urgency_level.dart';

/// A single donation "ask" posted by a requester/patient.
///
/// Field names deliberately mirror what the Laravel API will likely send
/// back from `GET /requests` (snake_case in [fromJson]) so wiring up the
/// real backend later is a drop-in change, not a rewrite.
class BloodRequest {
  final String id;
  final String hospitalName;
  final String area;
  final String requesterName;
  final BloodType bloodType;
  final UrgencyLevel urgency;
  final double distanceKm;
  final String postedAgo;
  final int unitsCollected;
  final int unitsNeeded;

  const BloodRequest({
    required this.id,
    required this.hospitalName,
    required this.area,
    required this.requesterName,
    required this.bloodType,
    required this.urgency,
    required this.distanceKm,
    required this.postedAgo,
    required this.unitsCollected,
    required this.unitsNeeded,
  });

  double get progress {
    if (unitsNeeded == 0) return 0;
    return (unitsCollected / unitsNeeded).clamp(0, 1).toDouble();
  }

  bool get isFulfilled => unitsCollected >= unitsNeeded;

  factory BloodRequest.fromJson(Map<String, dynamic> json) {
    return BloodRequest(
      id: json['id'].toString(),
      hospitalName: json['hospital_name'] as String,
      area: json['area'] as String,
      requesterName: json['requester_name'] as String,
      bloodType: BloodType.fromLabel(json['blood_type'] as String),
      urgency: UrgencyLevel.values.byName(json['urgency'] as String),
      distanceKm: (json['distance_km'] as num).toDouble(),
      postedAgo: json['posted_ago'] as String,
      unitsCollected: json['units_collected'] as int,
      unitsNeeded: json['units_needed'] as int,
    );
  }
}