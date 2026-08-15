import '../../models/blood_request.dart';
import '../../models/request_filter.dart';

/// Abstract data source for donation requests.
abstract class BloodRequestRepository {
  Future<List<BloodRequest>> getUrgentRequests();

  Future<List<BloodRequest>> getRequests({
    RequestFilter filter = RequestFilter.all,
    String query = '',
  });
}
