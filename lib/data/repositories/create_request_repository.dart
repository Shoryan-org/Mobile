import '../../models/new_request_payload.dart';

abstract class CreateRequestRepository {
  /// Submits a new request. Throws on failure so the screen can show an
  /// error message; the real implementation will POST to /requests.
  Future<void> submitRequest(NewRequestPayload payload);
}