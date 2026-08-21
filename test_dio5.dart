import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://shoryan-api.vercel.app/',
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    }
  ));
  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
    print('URI: ' + options.uri.toString());
    handler.next(options);
  }, onError: (e, handler) {
    final status = e.response?.statusCode?.toString() ?? 'null';
    print('ERROR: ' + status + ' for ' + e.requestOptions.uri.toString());
    final body = e.response?.data?.toString() ?? 'null';
    print('BODY: ' + body);
    handler.next(e);
  }));
  
  final paths = ['/chatbot', '/chatbot/'];
  for (var path in paths) {
    try {
      print('--- Testing ' + path + ' ---');
      await dio.post(path, data: {'message': 'test'});
    } catch(e) {}
  }
}
