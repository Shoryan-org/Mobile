import 'package:shoryan/core/network/token_storage.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;
  final TokenStorage _tokenStorage;

  AuthRepositoryImpl(this._dataSource, this._tokenStorage);

  @override
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final response = await _dataSource.signIn(email, password);
    // Extract and store the token
    final token = _extractToken(response);
    if (token != null) {
      await _tokenStorage.saveToken(token);
    }
    return response;
  }

  @override
  Future<Map<String, dynamic>> createAccount({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String address,
    required String bloodType,
    required String password,
    required String passwordConfirmation,
  }) {
    return _dataSource.createAccount(
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      address: address,
      bloodType: bloodType,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }

  @override
  Future<Map<String, dynamic>> verifyRegistrationEmail(
      String verificationId, String otp) async {
    final response =
        await _dataSource.verifyRegistrationEmail(verificationId, otp);
    // Some backends return a token after email verification
    final token = _extractToken(response);
    if (token != null) {
      await _tokenStorage.saveToken(token);
    }
    return response;
  }

  @override
  Future<Map<String, dynamic>> resendRegistrationOtp(String email) {
    return _dataSource.resendRegistrationOtp(email);
  }

  @override
  Future<Map<String, dynamic>> forgotPassword(String email) {
    return _dataSource.forgotPassword(email);
  }

  @override
  Future<Map<String, dynamic>> resendPasswordResetOtp(String email) {
    return _dataSource.resendPasswordResetOtp(email);
  }

  @override
  Future<Map<String, dynamic>> verifyPasswordResetOtp(
      String verificationId, String otp) {
    return _dataSource.verifyPasswordResetOtp(verificationId, otp);
  }

  @override
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) {
    return _dataSource.resetPassword(
      email: email,
      token: token,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }

  @override
  Future<Map<String, dynamic>> getCurrentUser() {
    return _dataSource.getCurrentUser();
  }

  @override
  Future<void> logout() async {
    try {
      await _dataSource.logout();
    } finally {
      // Always clear local token, even if server logout fails
      await _tokenStorage.clearToken();
    }
  }

  /// Extracts auth token from various response formats.
  String? _extractToken(Map<String, dynamic> response) {
    // Try common token locations in API responses
    if (response.containsKey('token')) {
      return response['token']?.toString();
    }
    if (response.containsKey('access_token')) {
      return response['access_token']?.toString();
    }
    final data = response['data'];
    if (data is Map<String, dynamic>) {
      if (data.containsKey('token')) {
        return data['token']?.toString();
      }
      if (data.containsKey('access_token')) {
        return data['access_token']?.toString();
      }
    }
    return null;
  }
}
