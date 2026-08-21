import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../domain/usecases/blood_request_usecases.dart';
import '../../../../data/repositories/blood_request_repository.dart';
import '../../../../models/smart_matching_response.dart';
import '../../../../models/hospital_model.dart';
import '../../../../models/blood_request.dart';

abstract class CreateRequestState {}
class CreateRequestInitial extends CreateRequestState {}
class CreateRequestLoading extends CreateRequestState {}
class CreateRequestSuccess extends CreateRequestState {
  final BloodRequest? request;
  final SmartMatchingResponse? smartMatching;
  final HospitalModel? nearestHospital;
  final double? distanceInMeters;

  CreateRequestSuccess({
    this.request,
    this.smartMatching,
    this.nearestHospital,
    this.distanceInMeters,
  });
}
class CreateRequestError extends CreateRequestState {
  final String message;
  CreateRequestError(this.message);
}

// Interface for fetching hospitals - allows connecting a real API later
abstract class HospitalRepository {
  Future<List<HospitalModel>> getHospitals();
}

// Temporary implementation providing dummy data until real API is connected
class MockHospitalRepository implements HospitalRepository {
  @override
  Future<List<HospitalModel>> getHospitals() async {
    return [
      const HospitalModel(id: 1, name: 'General Hospital', latitude: 30.0444, longitude: 31.2357),
      const HospitalModel(id: 2, name: 'City Clinic', latitude: 30.05, longitude: 31.24),
      const HospitalModel(id: 3, name: 'Mabra Zagazig', latitude: 30.5765383, longitude: 31.5040656),
    ];
  }
}

class CreateRequestCubit extends Cubit<CreateRequestState> {
  final CreateBloodRequestUseCase createBloodRequest;
  final BloodRequestRepository bloodRequestRepository;
  final HospitalRepository hospitalRepository;

  CreateRequestCubit({
    required this.createBloodRequest,
    required this.bloodRequestRepository,
    HospitalRepository? hospitalRepo,
  }) : hospitalRepository = hospitalRepo ?? MockHospitalRepository(),
       super(CreateRequestInitial());

  Future<void> create(Map<String, dynamic> data) async {
    // Prevent duplicate requests
    if (state is CreateRequestLoading) return;
    
    emit(CreateRequestLoading());
    try {
      // 1. Create the blood request
      final request = await createBloodRequest(data);
      
      // 2. Request smart matching
      SmartMatchingResponse? matchingResult;
      try {
        matchingResult = await bloodRequestRepository.getSmartMatching();
      } catch (e) {
        print('Smart matching failed: $e');
        // We don't fail the whole operation if smart matching fails
      }

      // 3. Find nearest hospital
      HospitalModel? nearest;
      double? minDistance;
      
      try {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (serviceEnabled) {
          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
          }
          
          if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
            Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
            
            final hospitals = await hospitalRepository.getHospitals();
            
            for (var hospital in hospitals) {
              if (hospital.latitude != null && hospital.longitude != null) {
                double distance = Geolocator.distanceBetween(
                  position.latitude, position.longitude,
                  hospital.latitude!, hospital.longitude!,
                );
                
                if (minDistance == null || distance < minDistance) {
                  minDistance = distance;
                  nearest = hospital;
                }
              }
            }
          }
        }
      } catch (e) {
        print('Location/Nearest hospital error: $e');
      }

      // 4. Return success state with data
      emit(CreateRequestSuccess(
        request: request,
        smartMatching: matchingResult,
        nearestHospital: nearest,
        distanceInMeters: minDistance,
      ));
    } catch (e) {
      // Return raw backend error if available
      emit(CreateRequestError(e.toString()));
    }

  }

}
