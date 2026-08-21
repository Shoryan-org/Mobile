class BloodResponseModel {
  final int id;
  final int userId;
  final int bloodRequestId;
  final String status;
  final String? createdAt;
  final String? updatedAt;

  const BloodResponseModel({
    required this.id,
    required this.userId,
    required this.bloodRequestId,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory BloodResponseModel.fromJson(Map<String, dynamic> json) {
    return BloodResponseModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      bloodRequestId: json['blood_request_id'] as int,
      status: json['status'] as String,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}
