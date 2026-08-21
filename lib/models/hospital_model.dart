class HospitalModel {
  final int id;
  final String name;
  final String? addressText;
  final double? latitude;
  final double? longitude;

  const HospitalModel({
    required this.id,
    required this.name,
    this.addressText,
    this.latitude,
    this.longitude,
  });

  factory HospitalModel.fromJson(Map<String, dynamic> json) {
    return HospitalModel(
      id: parseInt(json['id']),
      name: json['name'] as String? ?? '',
      addressText: json['address_text'] as String?,
      latitude: parseDouble(json['latitude']),
      longitude: parseDouble(json['longitude']),
    );
  }

  static double? parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static int parseInt(dynamic value, [int fallback = 0]) {  if (value == null) return fallback;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;}


}
