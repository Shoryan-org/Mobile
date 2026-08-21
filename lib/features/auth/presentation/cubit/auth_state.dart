import 'package:flutter/foundation.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

/// Emitted after successful login or session restore.
/// Carries the authenticated user's profile so downstream features can
/// read role information without making an extra network call.
class AuthAuthenticated extends AuthState {
  final int userId;
  final String userName;
  final bool isRequester;
  final bool isDonor;

  AuthAuthenticated({
    required this.userId,
    required this.userName,
    required this.isRequester,
    required this.isDonor,
  });
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthVerifyEmailSuccess extends AuthState {
  final String email;
  final String verificationId;
  AuthVerifyEmailSuccess(this.email, this.verificationId);
}

class AuthForgotPasswordSuccess extends AuthState {
  final String email;
  final String verificationId;
  AuthForgotPasswordSuccess(this.email, this.verificationId);
}

class AuthResetPasswordSuccess extends AuthState {}

class AuthResendOtpSuccess extends AuthState {}

/// Emitted when a resend-OTP call returns a fresh verification_id.
class AuthResendOtpSuccessWithId extends AuthState {
  final String verificationId;
  AuthResendOtpSuccessWithId(this.verificationId);
}

class AuthVerifyPasswordResetSuccess extends AuthState {
  final String email;
  final String token;
  AuthVerifyPasswordResetSuccess({required this.email, required this.token});
}
