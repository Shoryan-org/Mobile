import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(baseUrl: 'https://shoryan-api.vercel.app/'));
  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
    print('URI: \${options.uri.toString()}');
    handler.next(options);
  }, onError: (e, handler) {
    print('ERROR: \${e.response?.statusCode} for \${e.requestOptions.uri}');
    handler.next(e);
  }));
  
  final paths = ['/chatbot', 'chatbot', '/chatbot/', 'chatbot/'];
  
  for (final path in paths) {
    try {
      await dio.post(path);
    } catch(e) {}
  }
}
