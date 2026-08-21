import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'token_storage.dart';

class ApiClient {
  static ApiClient? _instance;
  late final Dio dio;
  TokenStorage? _tokenStorage;

  ApiClient._() {
    final baseUrl = dotenv.env['BASE_URL']!;
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
      ),
    );

    print('ENV BASE_URL => ${dotenv.env['BASE_URL']}');
    print('DIO BASE URL => ${dio.options.baseUrl}');

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _tokenStorage?.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          // Debug Logging
          print('--- AUTH REQUEST ---');
          print('${options.method} ${options.uri}');
          
          final safeHeaders = Map<String, dynamic>.from(options.headers);
          if (safeHeaders.containsKey('Authorization')) {
            safeHeaders['Authorization'] = '[REDACTED]';
          }
          print('Headers: $safeHeaders');
          
          if (options.data != null) {
            if (options.data is Map) {
              final safeData = Map<String, dynamic>.from(options.data);
              if (safeData.containsKey('password')) safeData['password'] = '[REDACTED]';
              if (safeData.containsKey('password_confirmation')) safeData['password_confirmation'] = '[REDACTED]';
              if (safeData.containsKey('token')) safeData['token'] = '[REDACTED]';
              print('Body: $safeData');
            } else {
              print('Body: ${options.data}');
            }
          }
          print('--------------------');
          
          handler.next(options);
        },
        onResponse: (response, handler) {
          print('--- AUTH RESPONSE ---');
          print('Status: ${response.statusCode}');
          print('Data: ${response.data}');
          print('---------------------');
          handler.next(response);
        },
        onError: (DioException e, handler) {
          print('--- AUTH ERROR ---');
          print('Type: ${e.type}');
          print('Message: ${e.message}');
          print('Status: ${e.response?.statusCode}');
          print('Error Data: ${e.response?.data}');
          print('------------------');
          handler.next(e);
        },
      ),
    );
  }

  static ApiClient get instance {
    _instance ??= ApiClient._();
    return _instance!;
  }

  void setTokenStorage(TokenStorage tokenStorage) {
    _tokenStorage = tokenStorage;
  }
}
