import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/blood_request_usecases.dart';
import '../../../../models/blood_request.dart';

abstract class RequesterBloodRequestsState {}
class RequesterBloodRequestsInitial extends RequesterBloodRequestsState {}
class RequesterBloodRequestsLoading extends RequesterBloodRequestsState {}
class RequesterBloodRequestsLoaded extends RequesterBloodRequestsState {
  final List<BloodRequest> requests;
  RequesterBloodRequestsLoaded(this.requests);
}
class RequesterBloodRequestsError extends RequesterBloodRequestsState {
  final String message;
  RequesterBloodRequestsError(this.message);
}

class RequesterBloodRequestsCubit extends Cubit<RequesterBloodRequestsState> {
  final GetMyBloodRequestsUseCase getMyBloodRequests;

  RequesterBloodRequestsCubit(this.getMyBloodRequests) : super(RequesterBloodRequestsInitial());

  Future<void> fetchMyRequests() async {
    emit(RequesterBloodRequestsLoading());
    try {
      final requests = await getMyBloodRequests();
      emit(RequesterBloodRequestsLoaded(requests));
    } catch (e) {
      emit(RequesterBloodRequestsError(e.toString()));
    }
  }
}
