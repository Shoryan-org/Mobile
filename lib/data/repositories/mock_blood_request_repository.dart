import '../../models/blood_request.dart';
import '../../models/blood_response_model.dart';
import '../../models/blood_type.dart';
import '../../models/request_filter.dart';
import '../../models/urgency_level.dart';
import '../../models/hospital_model.dart';
import '../../models/requester_model.dart';
import '../../models/smart_matching_response.dart';
import 'blood_request_repository.dart';

class MockBloodRequestRepository implements BloodRequestRepository {
  static final List<BloodRequest> _requests = [
    BloodRequest(
      id: 1,
      status: 'PENDING',
      bloodType: BloodType.oNegative,
      urgency: UrgencyLevel.critical,
      noOfUnits: 3,
      noOfUnitsDonated: 1,
      distance: 1.2,
      requestedAt: '6 min ago',
      hospital: const HospitalModel(id: 1, name: 'Al Nahda General Hospital', addressText: 'Nasr City'),
      requester: const RequesterModel(id: 1, name: 'Mariam H.'),
    ),
    BloodRequest(
      id: 2,
      status: 'PENDING',
      bloodType: BloodType.oPositive,
      urgency: UrgencyLevel.critical,
      noOfUnits: 5,
      noOfUnitsDonated: 3,
      distance: 3.6,
      requestedAt: '12 min ago',
      hospital: const HospitalModel(id: 2, name: 'Ain Shams University Hospital', addressText: 'Abbasia'),
      requester: const RequesterModel(id: 2, name: 'Nour E.'),
    ),
    BloodRequest(
      id: 3,
      status: 'PENDING',
      bloodType: BloodType.aPositive,
      urgency: UrgencyLevel.urgent,
      noOfUnits: 2,
      noOfUnitsDonated: 0,
      distance: 2.8,
      requestedAt: '24 min ago',
      hospital: const HospitalModel(id: 3, name: 'Dar El Shefa Medical Center', addressText: 'Heliopolis'),
      requester: const RequesterModel(id: 3, name: 'Youssef A.'),
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
        RequestFilter.compatible => r.urgency != UrgencyLevel.routine,
      };

      return matchesQuery && matchesFilter;
    }).toList();
  }

  @override
  Future<BloodRequest> createBloodRequest(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final hospitalData = data['hospital'] as Map<String, dynamic>?;
    final hospitalName = hospitalData?['name'] ?? 'Mock Hospital';
    final hospitalAddress = hospitalData?['address_text'] ?? 'Mock Area';

    final newReq = BloodRequest(
      id: _requests.length + 1,
      status: 'PENDING',
      bloodType: BloodType.fromLabel(data['blood_type']),
      urgency: UrgencyLevel.fromBackend(data['urgency']),
      noOfUnits: data['units_needed'] ?? data['no_of_units'] ?? 1,
      noOfUnitsDonated: 0,
      distance: 0.0,
      hospital: HospitalModel(id: 1, name: hospitalName, addressText: hospitalAddress),
      requester: const RequesterModel(id: 1, name: 'Current User'),
    );
    _requests.add(newReq);
    return newReq;
  }

  @override
  Future<List<BloodRequest>> getMyBloodRequests() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _requests.take(2).toList();
  }

  @override
  Future<List<BloodRequest>> getCompatibleBloodRequests() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _requests;
  }

  @override
  Future<BloodResponseModel> acceptBloodRequest(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return BloodResponseModel(id: 1, userId: 1, bloodRequestId: id, status: 'ACCEPT');
  }

  @override
  Future<BloodResponseModel> rejectBloodRequest(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return BloodResponseModel(id: 2, userId: 1, bloodRequestId: id, status: 'REJECT');
  }

  @override
  Future<List<BloodRequest>> getAcceptedBloodRequests() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [];
  }

  @override
  Future<SmartMatchingResponse> getSmartMatching() async {
    await Future.delayed(const Duration(milliseconds: 300));
    throw UnimplementedError();
  }
}