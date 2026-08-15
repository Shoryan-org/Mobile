import 'blood_type.dart';
import 'urgency_level.dart';

class NewRequestPayload {
  final BloodType bloodType;
  final UrgencyLevel urgency;
  final String hospital;
  final String locationArea;
  final int unitsRequired;
  final String notes;

  const NewRequestPayload({
    required this.bloodType,
    required this.urgency,
    required this.hospital,
    required this.locationArea,
    required this.unitsRequired,
    this.notes = '',
  });

  Map<String, dynamic> toJson() => {
    'blood_type': bloodType.label,
    'urgency': urgency.name,
    'hospital': hospital,
    'location_area': locationArea,
    'units_required': unitsRequired,
    'notes': notes,
  };
}