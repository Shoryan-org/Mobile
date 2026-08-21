import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    validateStatus: (status) => true,
  ));
  
  try {
    final res = await dio.get('https://shoryan-api.vercel.app/my-api/hospitals');
    print('Hospitals res code: ${res.statusCode}');
    print('Hospitals data: ${res.data}');

    final res2 = await dio.get('https://shoryan-api.vercel.app/my-api/auth/profile');
    print('Profile res code: ${res2.statusCode}');
    print('Profile data: ${res2.data}');

    final res3 = await dio.get('https://shoryan-api.vercel.app/hospitals');
    print('Hospitals (no my-api) res code: ${res3.statusCode}');
    print('Hospitals (no my-api) data: ${res3.data}');

    // Let's also check if login works so we get a token for auth/profile test
    final loginRes = await dio.post('https://shoryan-api.vercel.app/my-api/auth/login', data: {
      'email': 'hatem.ayman.508@gmail.com',
      'password': 'password123',
    });
    print('Login code: ${loginRes.statusCode}');
    print('Login res: ${loginRes.data}');

  } catch (e) {
    print(e);
  }
}
