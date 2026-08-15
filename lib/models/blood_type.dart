/// The 8 standard blood types. Keeping this as an enum (instead of a raw
/// String on every model)
/// means the compiler catches typos like "O_Neg"
enum BloodType {
  oNegative('O-'),
  oPositive('O+'),
  aNegative('A-'),
  aPositive('A+'),
  bNegative('B-'),
  bPositive('B+'),
  abNegative('AB-'),
  abPositive('AB+');

  final String label;

  const BloodType(this.label);

  /// O- donors can give to every blood type — shown as "Universal donor"
  /// in the mockups.
  bool get isUniversalDonor => this == BloodType.oNegative;

  static BloodType fromLabel(String label) {
    return BloodType.values.firstWhere(
          (type) => type.label == label,
      orElse: () => throw ArgumentError('Unknown blood type label: $label'),
    );
  }

  @override
  String toString() => label;
}