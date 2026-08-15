/// A nearby blood bank or donation-accepting hospital, shown in the
/// "Nearby blood banks" list on Home.
class BloodBank {
  final String name;
  final String type; //"Blood bank" or "Hospital"
  final double distanceKm;
  final bool isOpenNow;
  final String? closesAt;

  const BloodBank({
    required this.name,
    required this.type,
    required this.distanceKm,
    required this.isOpenNow,
    this.closesAt,
  });

  String get statusLabel {
    if (!isOpenNow) return 'Closed';
    return closesAt != null ? 'Open now · until $closesAt' : 'Open 24 hours';
  }
}