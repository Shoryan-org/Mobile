import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://shoryan-api.vercel.app/',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      },
    ),
  );

  try {
    print('Testing Login Endpoint...');
    final response = await dio.post(
      '/my-api/auth/login',
      data: {
        'email': 'hatem.ayman.508@gmail.com', // random email
        'password': 'wrongpassword123',
      },
    );
    print('Response Status: ${response.statusCode}');
    print('Response Data: ${response.data}');
  } on DioException catch (e) {
    print('Dio Error:');
    print('Type: ${e.type}');
    print('Message: ${e.message}');
    if (e.response != null) {
      print('Status: ${e.response?.statusCode}');
      print('Data: ${e.response?.data}');
    }
  } catch (e) {
    print('Unknown error: $e');
  }
}
