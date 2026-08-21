import '../../models/blood_request.dart';
import '../../models/blood_response_model.dart';
import '../../models/request_filter.dart';
import '../../models/smart_matching_response.dart';

abstract class BloodRequestRepository {
  Future<List<BloodRequest>> getUrgentRequests();

  Future<List<BloodRequest>> getRequests({
    RequestFilter filter = RequestFilter.all,
    String query = '',
  });

  Future<BloodRequest> createBloodRequest(Map<String, dynamic> data);
  Future<List<BloodRequest>> getMyBloodRequests();
  Future<List<BloodRequest>> getCompatibleBloodRequests();
  Future<BloodResponseModel> acceptBloodRequest(int id);
  Future<BloodResponseModel> rejectBloodRequest(int id);
  Future<List<BloodRequest>> getAcceptedBloodRequests();
  Future<SmartMatchingResponse> getSmartMatching();
}
