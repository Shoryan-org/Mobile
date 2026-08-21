import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(AuthInitial());

  bool get isDonor {
    if (state is AuthAuthenticated) {
      return (state as AuthAuthenticated).isDonor;
    }
    return false;
  }

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      final response = await _repository.signIn(email, password);
      // After login, fetch the full user profile to get role info
      await _emitAuthenticatedFromMe();
    } catch (e) {
      emit(AuthError(_extractMessage(e)));
    }
  }

  Future<void> createAccount({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String address,
    required String bloodType,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(AuthLoading());
    try {
      final response = await _repository.createAccount(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        address: address,
        bloodType: bloodType,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      final verificationId = _extractVerificationId(response);
      emit(AuthVerifyEmailSuccess(email, verificationId));
    } catch (e) {
      emit(AuthError(_extractMessage(e)));
    }
  }

  Future<void> verifyRegistrationEmail(String verificationId, String otp) async {
    emit(AuthLoading());
    try {
      await _repository.verifyRegistrationEmail(verificationId, otp);
      // After email verification, fetch profile to get role info
      await _emitAuthenticatedFromMe();
    } catch (e) {
      emit(AuthError(_extractMessage(e)));
    }
  }

  Future<void> resendRegistrationOtp(String email) async {
    emit(AuthLoading());
    try {
      final response = await _repository.resendRegistrationOtp(email);
      final verificationId = _extractVerificationId(response);
      if (verificationId.isNotEmpty) {
        emit(AuthResendOtpSuccessWithId(verificationId));
      } else {
        emit(AuthResendOtpSuccess());
      }
    } catch (e) {
      emit(AuthError(_extractMessage(e)));
    }
  }

  Future<void> forgotPassword(String email) async {
    emit(AuthLoading());
    try {
      final response = await _repository.forgotPassword(email);
      final verificationId = _extractVerificationId(response);
      emit(AuthForgotPasswordSuccess(email, verificationId));
    } catch (e) {
      emit(AuthError(_extractMessage(e)));
    }
  }

  Future<void> resendPasswordResetOtp(String email) async {
    emit(AuthLoading());
    try {
      final response = await _repository.resendPasswordResetOtp(email);
      final verificationId = _extractVerificationId(response);
      if (verificationId.isNotEmpty) {
        emit(AuthResendOtpSuccessWithId(verificationId));
      } else {
        emit(AuthResendOtpSuccess());
      }
    } catch (e) {
      emit(AuthError(_extractMessage(e)));
    }
  }

  Future<void> verifyPasswordResetOtp(String verificationId, String otp) async {
    emit(AuthLoading());
    try {
      final response = await _repository.verifyPasswordResetOtp(verificationId, otp);
      final token = _extractResetToken(response);
      emit(AuthVerifyPasswordResetSuccess(email: '', token: token));
    } catch (e) {
      emit(AuthError(_extractMessage(e)));
    }
  }

  Future<void> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(AuthLoading());
    try {
      await _repository.resetPassword(
        email: email,
        token: token,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      emit(AuthResetPasswordSuccess());
    } catch (e) {
      emit(AuthError(_extractMessage(e)));
    }
  }

  /// Called on app start to restore session from stored token.
  /// Fetches /me to get current user profile and roles.
  Future<void> getCurrentUser() async {
    emit(AuthLoading());
    try {
      await _emitAuthenticatedFromMe();
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await _repository.logout();
    } catch (_) {
      // Even if server logout fails, clear local session
    } finally {
      emit(AuthUnauthenticated());
    }
  }

  /// Fetches /me and emits [AuthAuthenticated] with user profile & roles.
  Future<void> _emitAuthenticatedFromMe() async {
    final meResponse = await _repository.getCurrentUser();
    final data = meResponse['data'] as Map<String, dynamic>? ?? meResponse;

    final userId = (data['id'] as num?)?.toInt() ?? 0;
    final userName = data['name'] as String? ?? '';

    // The backend may return roles as a list of role names or booleans.
    // Support both patterns safely.
    bool isRequester = false;
    bool isDonor = false;

    if (data.containsKey('roles')) {
      final roles = data['roles'];
      if (roles is List) {
        // e.g. ["donor", "requester"]
        final roleStrings = roles.map((r) => r.toString().toLowerCase()).toList();
        isRequester = roleStrings.contains('requester');
        isDonor = roleStrings.contains('donor');
      }
    }

    // Also support explicit boolean flags if the backend returns them
    if (data.containsKey('is_requester')) {
      isRequester = data['is_requester'] == true;
    }
    if (data.containsKey('is_donor')) {
      isDonor = data['is_donor'] == true;
    }

    // If no role info at all, default to showing both flows
    if (!isRequester && !isDonor) {
      isRequester = true;
      isDonor = true;
    }

    emit(AuthAuthenticated(
      userId: userId,
      userName: userName,
      isRequester: isRequester,
      isDonor: isDonor,
    ));
  }

  /// Extracts a clean error message from an exception.
  String _extractMessage(Object e) {
    final msg = e.toString();
    if (msg.startsWith('Exception: ')) {
      return msg.substring(11);
    }
    return msg;
  }

  /// Extracts the verification_id from an API response.
  String _extractVerificationId(Map<String, dynamic> response) {
    if (response.containsKey('verification_id')) {
      return response['verification_id']?.toString() ?? '';
    }
    final data = response['data'];
    if (data is Map<String, dynamic>) {
      if (data.containsKey('verification_id')) {
        return data['verification_id']?.toString() ?? '';
      }
    }
    return '';
  }

  /// Extracts reset token from password reset OTP verification response.
  String _extractResetToken(Map<String, dynamic> response) {
    if (response.containsKey('token')) {
      return response['token']?.toString() ?? '';
    }
    final data = response['data'];
    if (data is Map<String, dynamic>) {
      if (data.containsKey('token')) {
        return data['token']?.toString() ?? '';
      }
    }
    return '';
  }
}
