class RequesterModel {
  final int id;
  final String name;

  const RequesterModel({
    required this.id,
    required this.name,
  });

  factory RequesterModel.fromJson(Map<String, dynamic> json) {
    return RequesterModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}
