import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/network/token_storage.dart';

class ChatRemoteDataSource {
  late final Dio _dio;

  ChatRemoteDataSource(TokenStorage tokenStorage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://shoryan-api.vercel.app/',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = tokenStorage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  /// Retrieves chat history.
  /// GET /chatbot/messages
  Future<List<dynamic>> getChatHistory() async {
    try {
      final requestUrl = '${_dio.options.baseUrl}my-api/chatbot/messages';
      debugPrint('BASE URL => ${_dio.options.baseUrl}');
      debugPrint('CHATBOT URL => $requestUrl');
      debugPrint('--- CHATBOT REQUEST ---');
      debugPrint('Headers: ${_dio.options.headers}');

      final response = await _dio.get('/my-api/chatbot/messages');

      debugPrint('--- CHATBOT RESPONSE ---');
      debugPrint('Status: ${response.statusCode}');
      debugPrint('Body: ${response.data}');

      if (response.data is Map<String, dynamic>) {
        final data = response.data['data'];
        if (data is List) {
          return data;
        }
      }
      return [];
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Sends a new message to the chatbot.
  /// POST /chatbot/
  Future<Map<String, dynamic>> sendChatMessage(String message, String? sessionId) async {
    try {
      final data = <String, dynamic>{'message': message};
      if (sessionId != null) {
        data['session_id'] = sessionId;
      }
      
      final requestUrl = 'https://shoryan-api.vercel.app/my-api/chatbot/';
      debugPrint('BASE URL => ${_dio.options.baseUrl}');
      debugPrint('CHATBOT URL => $requestUrl');
      debugPrint('--- CHATBOT REQUEST ---');
      debugPrint('Headers: ${_dio.options.headers}');
      debugPrint('Body: $data');

      final response = await _dio.post(
        '/my-api/chatbot/',
        data: data,
      );
      
      debugPrint('--- CHATBOT RESPONSE ---');
      debugPrint('Status: ${response.statusCode}');
      debugPrint('Body: ${response.data}');

      if (response.data is Map<String, dynamic>) {
        return response.data['data'] as Map<String, dynamic>? ?? {};
      }
      return {};
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e, stack) {
      debugPrint('--- CHATBOT PARSING ERROR ---');
      debugPrint('Error: $e');
      debugPrint('Stack: $stack');
      throw Exception('Parsing Error: $e');
    }
  }

  Exception _handleDioError(DioException e) {
    if (e.response != null) {
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;
      String message = 'API Error';

      if (responseData is Map<String, dynamic>) {
        if (responseData.containsKey('message')) {
          message = responseData['message'].toString();
        } else if (responseData.containsKey('error')) {
          message = responseData['error'].toString();
        }
      } else if (responseData != null) {
        message = responseData.toString();
      }
      
      debugPrint('--- BACKEND ERROR RESPONSE ---');
      debugPrint('Status Code: $statusCode');
      debugPrint('Response Body contains ngrok?: ${message.contains('ngrok')}');
      debugPrint('Full Error Body: $message');
      
      return Exception('[$statusCode] $message');
    }
    
    debugPrint('--- CHATBOT NETWORK ERROR ---');
    debugPrint('Method: ${e.requestOptions.method}');
    debugPrint('URL: ${e.requestOptions.uri}');
    debugPrint('Message: ${e.message}');
    return Exception('Network Error: ${e.message ?? 'Unable to connect to server'}');
  }
}
