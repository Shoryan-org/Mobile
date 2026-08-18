import '../../models/new_request_payload.dart';
import 'create_request_repository.dart';

class MockCreateRequestRepository implements CreateRequestRepository {
  @override
  Future<void> submitRequest(NewRequestPayload payload) async {
    await Future.delayed(const Duration(milliseconds: 400));
    print('Mock submit: ${payload.toJson()}');
  }
}