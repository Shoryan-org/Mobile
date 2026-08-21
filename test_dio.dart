import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(baseUrl: 'https://shoryan-api.vercel.app/'));
  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
    print('URI: ' + options.uri.toString());
    handler.next(options);
  }));
  try {
    await dio.post('/chatbot/');
  } catch(e) {
    print(e);
  }
}
