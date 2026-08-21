import '../../data/repositories/blood_request_repository.dart';
import '../../models/blood_request.dart';
import '../../models/blood_response_model.dart';

class GetMyBloodRequestsUseCase {
  final BloodRequestRepository repository;
  GetMyBloodRequestsUseCase(this.repository);
  Future<List<BloodRequest>> call() => repository.getMyBloodRequests();
}

class GetCompatibleBloodRequestsUseCase {
  final BloodRequestRepository repository;
  GetCompatibleBloodRequestsUseCase(this.repository);
  Future<List<BloodRequest>> call() => repository.getCompatibleBloodRequests();
}

class CreateBloodRequestUseCase {
  final BloodRequestRepository repository;
  CreateBloodRequestUseCase(this.repository);
  Future<BloodRequest> call(Map<String, dynamic> data) => repository.createBloodRequest(data);
}

class AcceptBloodRequestUseCase {
  final BloodRequestRepository repository;
  AcceptBloodRequestUseCase(this.repository);
  Future<BloodResponseModel> call(int id) => repository.acceptBloodRequest(id);
}

class RejectBloodRequestUseCase {
  final BloodRequestRepository repository;
  RejectBloodRequestUseCase(this.repository);
  Future<BloodResponseModel> call(int id) => repository.rejectBloodRequest(id);
}

class GetAcceptedBloodRequestsUseCase {
  final BloodRequestRepository repository;
  GetAcceptedBloodRequestsUseCase(this.repository);
  Future<List<BloodRequest>> call() => repository.getAcceptedBloodRequests();
}
