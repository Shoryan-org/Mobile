import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/blood_request_usecases.dart';

abstract class BloodRequestActionState {}
class BloodRequestActionInitial extends BloodRequestActionState {}
class BloodRequestActionLoading extends BloodRequestActionState {
  final int requestId;
  BloodRequestActionLoading(this.requestId);
}
class BloodRequestActionSuccess extends BloodRequestActionState {
  final int requestId;
  final String action; // 'accept' or 'reject'
  BloodRequestActionSuccess(this.requestId, this.action);
}
class BloodRequestActionError extends BloodRequestActionState {
  final int requestId;
  final String message;
  BloodRequestActionError(this.requestId, this.message);
}

class BloodRequestActionCubit extends Cubit<BloodRequestActionState> {
  final AcceptBloodRequestUseCase acceptBloodRequest;
  final RejectBloodRequestUseCase rejectBloodRequest;

  BloodRequestActionCubit(this.acceptBloodRequest, this.rejectBloodRequest) : super(BloodRequestActionInitial());

  Future<void> accept(int requestId) async {
    emit(BloodRequestActionLoading(requestId));
    try {
      await acceptBloodRequest(requestId);
      emit(BloodRequestActionSuccess(requestId, 'accept'));
    } catch (e) {
      emit(BloodRequestActionError(requestId, e.toString()));
    }
  }

  Future<void> reject(int requestId) async {
    emit(BloodRequestActionLoading(requestId));
    try {
      await rejectBloodRequest(requestId);
      emit(BloodRequestActionSuccess(requestId, 'reject'));
    } catch (e) {
      emit(BloodRequestActionError(requestId, e.toString()));
    }
  }
}
