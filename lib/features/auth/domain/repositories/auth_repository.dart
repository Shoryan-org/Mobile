abstract class AuthRepository {
  Future<Map<String, dynamic>> signIn(String email, String password);

  Future<Map<String, dynamic>> createAccount({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String address,
    required String bloodType,
    required String password,
    required String passwordConfirmation,
  });

  Future<Map<String, dynamic>> verifyRegistrationEmail(String verificationId, String otp);

  Future<Map<String, dynamic>> resendRegistrationOtp(String email);

  Future<Map<String, dynamic>> forgotPassword(String email);

  Future<Map<String, dynamic>> resendPasswordResetOtp(String email);

  Future<Map<String, dynamic>> verifyPasswordResetOtp(String verificationId, String otp);

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  });

  Future<Map<String, dynamic>> getCurrentUser();

  Future<void> logout();
}
