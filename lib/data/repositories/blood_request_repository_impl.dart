import '../../models/blood_request.dart';
import '../../models/blood_response_model.dart';
import '../../models/request_filter.dart';
import '../../models/smart_matching_response.dart';
import '../datasources/blood_request_remote_data_source.dart';
import 'blood_request_repository.dart';

class BloodRequestRepositoryImpl implements BloodRequestRepository {
  final BloodRequestRemoteDataSource remoteDataSource;

  BloodRequestRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<BloodRequest>> getUrgentRequests() async {
    final response = await remoteDataSource.getCompatibleBloodRequests();
    final requests = _parseBloodRequestList(response);
    return requests.where((r) => r.urgency.name == 'emergency' || r.urgency.name == 'critical').toList();
  }

  @override
  Future<List<BloodRequest>> getRequests({
    RequestFilter filter = RequestFilter.all,
    String query = '',
  }) async {
    final response = await remoteDataSource.getCompatibleBloodRequests();
    return _parseBloodRequestList(response);
  }

  @override
  Future<BloodRequest> createBloodRequest(Map<String, dynamic> data) async {
    final response = await remoteDataSource.createBloodRequest(data);
    // Create response: {"data": {single object}}
    final dataMap = response['data'] as Map<String, dynamic>;
    return BloodRequest.fromJson(dataMap);
  }

  @override
  Future<List<BloodRequest>> getMyBloodRequests() async {
    final response = await remoteDataSource.getMyBloodRequests();
    return _parseBloodRequestList(response);
  }

  @override
  Future<List<BloodRequest>> getCompatibleBloodRequests() async {
    final response = await remoteDataSource.getCompatibleBloodRequests();
    return _parseBloodRequestList(response);
  }

  @override
  Future<BloodResponseModel> acceptBloodRequest(int id) async {
    final response = await remoteDataSource.acceptBloodRequest(id);
    // Accept response: {"data": {single object}}
    final dataMap = response['data'] as Map<String, dynamic>;
    return BloodResponseModel.fromJson(dataMap);
  }

  @override
  Future<BloodResponseModel> rejectBloodRequest(int id) async {
    final response = await remoteDataSource.rejectBloodRequest(id);
    // Reject response: {"data": {single object}}
    final dataMap = response['data'] as Map<String, dynamic>;
    return BloodResponseModel.fromJson(dataMap);
  }

  @override
  Future<List<BloodRequest>> getAcceptedBloodRequests() async {
    final response = await remoteDataSource.getAcceptedBloodRequests();
    return _parseBloodRequestList(response);
  }

  @override
  Future<SmartMatchingResponse> getSmartMatching() async {
    final response = await remoteDataSource.getSmartMatching();
    return SmartMatchingResponse.fromJson(response);
  }

  /// Safely parses the standard list-wrapper response:
  ///   {"message": "...", "data": [...]}
  /// into a typed List<BloodRequest>.
  List<BloodRequest> _parseBloodRequestList(Map<String, dynamic> response) {
    final rawData = response['data'];
    if (rawData is List) {
      return rawData
          .map((item) => BloodRequest.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    // If 'data' is missing or not a list, return empty.
    return [];
  }
}
