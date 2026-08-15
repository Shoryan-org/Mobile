import '../../models/blood_request.dart';
import '../../models/blood_type.dart';
import '../../models/request_filter.dart';
import '../../models/urgency_level.dart';
import 'blood_request_repository.dart';

/// Static in-memory dataset that mirrors the requests shown in the UI
/// mockups, wrapped in fake network delays so the loading states in
/// HomeScreen/RequestsScreen already behave like they will against the
/// real API.
class MockBloodRequestRepository implements BloodRequestRepository {
  static final List<BloodRequest> _requests = [
    const BloodRequest(
      id: 'r1',
      hospitalName: 'Al Nahda General Hospital',
      area: 'Nasr City',
      requesterName: 'Mariam H.',
      bloodType: BloodType.oNegative,
      urgency: UrgencyLevel.critical,
      distanceKm: 1.2,
      postedAgo: '6 min ago',
      unitsCollected: 1,
      unitsNeeded: 3,
    ),
    const BloodRequest(
      id: 'r2',
      hospitalName: 'Ain Shams University Hospital',
      area: 'Abbasia',
      requesterName: 'Nour E.',
      bloodType: BloodType.oPositive,
      urgency: UrgencyLevel.critical,
      distanceKm: 3.6,
      postedAgo: '12 min ago',
      unitsCollected: 3,
      unitsNeeded: 5,
    ),
    const BloodRequest(
      id: 'r3',
      hospitalName: 'Dar El Shefa Medical Center',
      area: 'Heliopolis',
      requesterName: 'Youssef A.',
      bloodType: BloodType.aPositive,
      urgency: UrgencyLevel.urgent,
      distanceKm: 2.8,
      postedAgo: '24 min ago',
      unitsCollected: 0,
      unitsNeeded: 2,
    ),
    const BloodRequest(
      id: 'r4',
      hospitalName: "Cairo Children's Cancer Hospital",
      area: 'Sayeda Zeinab',
      requesterName: 'Hala S.',
      bloodType: BloodType.bPositive,
      urgency: UrgencyLevel.urgent,
      distanceKm: 5.4,
      postedAgo: '1 hr ago',
      unitsCollected: 2,
      unitsNeeded: 4,
    ),
    const BloodRequest(
      id: 'r5',
      hospitalName: 'Maadi Military Hospital',
      area: 'Maadi',
      requesterName: 'Omar K.',
      bloodType: BloodType.abNegative,
      urgency: UrgencyLevel.routine,
      distanceKm: 8.9,
      postedAgo: '3 hrs ago',
      unitsCollected: 0,
      unitsNeeded: 1,
    ),
  ];

  @override
  Future<List<BloodRequest>> getUrgentRequests() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _requests.where((r) => r.urgency == UrgencyLevel.critical).toList();
  }

  @override
  Future<List<BloodRequest>> getRequests({
    RequestFilter filter = RequestFilter.all,
    String query = '',
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _requests.where((r) {
      final matchesQuery = query.isEmpty ||
          r.hospitalName.toLowerCase().contains(query.toLowerCase()) ||
          r.area.toLowerCase().contains(query.toLowerCase());

      final matchesFilter = switch (filter) {
        RequestFilter.all => true,
        RequestFilter.critical => r.urgency == UrgencyLevel.critical,
        RequestFilter.routine => r.urgency == UrgencyLevel.routine,
      // "Compatible" will eventually be computed against the signed-in
      // donor's blood type by the AI matching service; for now it just
      // hides routine asks as a placeholder.
        RequestFilter.compatible => r.urgency != UrgencyLevel.routine,
      };

      return matchesQuery && matchesFilter;
    }).toList();
  }
}