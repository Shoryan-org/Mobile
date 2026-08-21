import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/blood_request_usecases.dart';
import '../../../../models/blood_request.dart';

abstract class DonorBloodRequestsState {}
class DonorBloodRequestsInitial extends DonorBloodRequestsState {}
class DonorBloodRequestsLoading extends DonorBloodRequestsState {}
class DonorBloodRequestsLoaded extends DonorBloodRequestsState {
  final List<BloodRequest> compatibleRequests;
  final List<BloodRequest> acceptedRequests;
  DonorBloodRequestsLoaded({required this.compatibleRequests, required this.acceptedRequests});
}
class DonorBloodRequestsError extends DonorBloodRequestsState {
  final String message;
  DonorBloodRequestsError(this.message);
}

class DonorBloodRequestsCubit extends Cubit<DonorBloodRequestsState> {
  final GetCompatibleBloodRequestsUseCase getCompatibleRequests;
  final GetAcceptedBloodRequestsUseCase getAcceptedRequests;

  DonorBloodRequestsCubit(this.getCompatibleRequests, this.getAcceptedRequests) : super(DonorBloodRequestsInitial());

  Future<void> fetchDonorRequests() async {
    emit(DonorBloodRequestsLoading());
    try {
      final compatible = await getCompatibleRequests();
      final accepted = await getAcceptedRequests();
      emit(DonorBloodRequestsLoaded(compatibleRequests: compatible, acceptedRequests: accepted));
    } catch (e) {
      emit(DonorBloodRequestsError(e.toString()));
    }
  }
}
