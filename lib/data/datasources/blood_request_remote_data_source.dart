import 'dart:convert';
import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';

class BloodRequestRemoteDataSource {
  final Dio _dio = ApiClient.instance.dio;

  Future<Response> _request(Future<Response> requestFuture) async {
    Response response;
    try {
      response = await requestFuture;
    } on DioException catch (e) {
      if (e.response != null) {
        _logApi(e.response!);
      }
      rethrow;
    }
    _logApi(response);
    return response;
  }

  void _logApi(Response response) {
    print('--- Requests API Debug ---');
    print('HTTP method: ${response.requestOptions.method}');
    print('Final URL: ${response.requestOptions.uri}');
    if (response.requestOptions.data != null) {
      print('Request body: ${response.requestOptions.data}');
    }
    print('Status code: ${response.statusCode}');
    print('Response content type: ${response.headers.value('content-type')}');
    print('Response body: ${response.data}');
    print('--------------------------');
  }

  Future<Map<String, dynamic>> createBloodRequest(Map<String, dynamic> data) async {
    try {
      final response = await _request(_dio.post('/my-api/blood-requests', data: data));
      return _ensureMap(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
  Future<Map<String, dynamic>> getMyBloodRequests() async {
    try {
      final response = await _request(
        _dio.get('/my-api/blood-requests', queryParameters: {'show': 'compatible'}),
      );
      return _ensureMap(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> getCompatibleBloodRequests() async {
    try {
      final response = await _request(_dio.get('/my-api/blood-requests', queryParameters: {'show': 'compatible'}));
      return _ensureMap(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> acceptBloodRequest(int id) async {
    try {
      final response = await _request(_dio.post('/my-api/blood-requests/$id/accept'));
      return _ensureMap(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> rejectBloodRequest(int id) async {
    try {
      final response = await _request(_dio.post('/my-api/blood-requests/$id/reject'));
      return _ensureMap(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> getAcceptedBloodRequests() async {
    try {
      final response = await _request(_dio.get('/my-api/responses/accepted'));
      return _ensureMap(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> getSmartMatching() async {
    try {
      final response = await _request(_dio.get('/smart-matching'));
      return _ensureMap(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Safely converts Dio's response.data (which is `dynamic`) into a
  /// strongly-typed Map.  Dio auto-decodes JSON when the response
  /// Content-Type is application/json, but some servers return a plain
  /// String.  This method handles both cases.
  Map<String, dynamic> _ensureMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is String) {
      final decoded = jsonDecode(data);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      // Wrap unexpected decoded types so callers always get a Map.
      return <String, dynamic>{'data': decoded};
    }
    // Fallback: wrap raw data.
    return <String, dynamic>{'data': data};
  }

  Exception _handleDioError(DioException e) {
    if (e.response != null) {
      final errorData = e.response?.data;
      String message = 'An error occurred';
      if (errorData is Map<String, dynamic>) {
        message = errorData['message'] as String? ?? message;
      } else if (errorData is String) {
        try {
          final decoded = jsonDecode(errorData);
          if (decoded is Map<String, dynamic>) {
            message = decoded['message'] as String? ?? message;
          }
        } catch (_) {
          message = errorData;
        }
      }
      return Exception(message);
    }
    return Exception(e.message ?? 'Network error');
  }
}
