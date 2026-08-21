import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shoryan/core/network/api_client.dart';

/// Remote data source that communicates with the backend Auth API.
class AuthRemoteDataSource {
  final Dio _dio = ApiClient.instance.dio;

  /// POST /my-api/auth/login
  Future<Map<String, dynamic>> signIn(
      String email,
      String password,
      ) async {
    try {
      final response = await _dio.post(
        '/my-api/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST /my-api/auth/register
  Future<Map<String, dynamic>> createAccount({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String address,
    required String bloodType,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _dio.post(
        '/my-api/auth/register',
        data: {
          'name': fullName,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'phone': phoneNumber,
          'blood_type': bloodType,
          'address': {
            'latitude': 0.0,
            'longitude': 0.0,
            'address_text': address,
          },
        },
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST /my-api/auth/register/verify-email
  /// Body: { verification_id: UUID, otp: string }
  Future<Map<String, dynamic>> verifyRegistrationEmail(
      String verificationId,
      String otp,
      ) async {
    try {
      final response = await _dio.post(
        '/my-api/auth/register/verify-email',
        data: {
          'verification_id': verificationId,
          'otp': otp,
        },
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST /my-api/auth/resend-registration-otp
  Future<Map<String, dynamic>> resendRegistrationOtp(
      String email,
      ) async {
    try {
      final response = await _dio.post(
        '/my-api/auth/resend-registration-otp',
        data: {
          'email': email,
        },
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST /my-api/auth/forgot-password
  Future<Map<String, dynamic>> forgotPassword(
      String email,
      ) async {
    try {
      final response = await _dio.post(
        '/my-api/auth/forgot-password',
        data: {
          'email': email,
        },
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST /my-api/auth/resend-password-reset-otp
  Future<Map<String, dynamic>> resendPasswordResetOtp(
      String email,
      ) async {
    try {
      final response = await _dio.post(
        '/my-api/auth/resend-password-reset-otp',
        data: {
          'email': email,
        },
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST /my-api/auth/verify-password-reset
  /// Body: { verification_id: UUID, otp: string }
  Future<Map<String, dynamic>> verifyPasswordResetOtp(
      String verificationId,
      String otp,
      ) async {
    try {
      final response = await _dio.post(
        '/my-api/auth/verify-password-reset',
        data: {
          'verification_id': verificationId,
          'otp': otp,
        },
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST /my-api/auth/password-reset
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _dio.post(
        '/my-api/auth/password-reset',
        data: {
          'email': email,
          'token': token,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// GET /my-api/auth/me
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _dio.get('/my-api/auth/me');

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// DELETE /my-api/auth/logout
  Future<void> logout() async {
    try {
      await _dio.delete('/my-api/auth/logout');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Handles successful API responses.
  Map<String, dynamic> _handleResponse(Response response) {
    final data = response.data;

    if (data is Map<String, dynamic>) {
      return data;
    }

    return {
      'data': data,
    };
  }

  /// Handles Dio/API errors.
  Exception _handleDioError(DioException e) {
    debugPrint('Handling DioError: ${e.message}');

    // Server returned a response.
    if (e.response != null) {
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;

      debugPrint('Status Code: $statusCode');
      debugPrint('Response Data: $responseData');

      String message = 'API Error';

      if (responseData is Map<String, dynamic>) {
        // Validation errors - 422
        if (statusCode == 422 &&
            responseData.containsKey('errors')) {
          final errors = responseData['errors'];

          if (errors is Map<String, dynamic> &&
              errors.isNotEmpty) {
            final firstError = errors.values.first;

            if (firstError is List && firstError.isNotEmpty) {
              message = firstError.first.toString();
            } else {
              message = firstError.toString();
            }
          }
        }

        // Normal backend message
        else if (responseData.containsKey('message')) {
          message = responseData['message'].toString();
        }

        // Backend error field
        else if (responseData.containsKey('error')) {
          message = responseData['error'].toString();
        }

        // Fallback
        else {
          message = responseData.toString();
        }
      } else if (responseData != null) {
        message = responseData.toString();
      }

      return Exception('[$statusCode] $message');
    }

    // No response = network/connection problem.
    return Exception(
      'Network Error: ${e.message ?? 'Unable to connect to server'}',
    );
  }
}