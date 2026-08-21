import 'blood_type.dart';
import 'urgency_level.dart';
import 'hospital_model.dart';
import 'requester_model.dart';

class BloodRequest {
  final int id;
  final String status;
  final BloodType bloodType;
  final UrgencyLevel urgency;
  final int noOfUnits;
  final int? noOfUnitsDonated;
  final String? notes;
  final double? distance;
  final String? requestedAt;
  final String? createdAt;
  final String? updatedAt;
  final HospitalModel? hospital;
  final RequesterModel? requester;
  final int? requesterId;

  const BloodRequest({
    required this.id,
    required this.status,
    required this.bloodType,
    required this.urgency,
    required this.noOfUnits,
    this.noOfUnitsDonated,
    this.notes,
    this.distance,
    this.requestedAt,
    this.createdAt,
    this.updatedAt,
    this.hospital,
    this.requester,
    this.requesterId,
  });

  String get hospitalName => hospital?.name ?? 'Unknown Hospital';
  String get area => hospital?.addressText ?? 'Unknown Area';
  String get requesterName => requester?.name ?? 'Unknown Requester';
  double get distanceKm => distance ?? 0.0;
  String get postedAgo => requestedAt ?? createdAt ?? '';
  int get unitsCollected => noOfUnitsDonated ?? 0;
  int get unitsNeeded => noOfUnits;

  double get progress {
    if (unitsNeeded == 0) return 0;
    return (unitsCollected / unitsNeeded).clamp(0, 1).toDouble();
  }

  bool get isFulfilled => unitsCollected >= unitsNeeded;

  factory BloodRequest.fromJson(Map<String, dynamic> json) {
    // Parse nested hospital — always a single object or null, never a list.
    HospitalModel? hospital;
    if (json['hospital'] != null && json['hospital'] is Map<String, dynamic>) {
      hospital = HospitalModel.fromJson(json['hospital'] as Map<String, dynamic>);
    }

    // Parse nested requester — always a single object or null, never a list.
    RequesterModel? requester;
    if (json['requester'] != null && json['requester'] is Map<String, dynamic>) {
      requester = RequesterModel.fromJson(json['requester'] as Map<String, dynamic>);
    }

    return BloodRequest(
      id: json['id'] as int,
      status: json['status'] as String? ?? 'PENDING',
      bloodType: BloodType.fromLabel(json['blood_type'] as String),
      urgency: UrgencyLevel.fromBackend(json['urgency'] as String),
      noOfUnits: json['no_of_units'] as int,
      noOfUnitsDonated: json['no_of_units_donated'] as int?,
      notes: json['notes'] as String?,
      requestedAt: json['requested_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      hospital: hospital,
      requester: requester,
      requesterId: json['requester_id'] as int?,
      distance: parseDouble(json['distance']),
    );
  }
  static double? parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}