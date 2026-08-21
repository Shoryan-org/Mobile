import 'package:dio/dio.dart';
import 'dart:io';

const baseUrl = 'https://shoryan-api.vercel.app';

void main() async {
  final dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
    },
    validateStatus: (status) => true,
  ));

  stdout.writeln('=== STEP 1: Login ===');
  final loginRes = await dio.post(
    '$baseUrl/my-api/auth/login',
    data: {
      'email': 'hatem.ayman.508@gmail.com',
      'password': 'Hatem@508',
    },
  );
  stdout.writeln('Status: ${loginRes.statusCode}');
  stdout.writeln('Data: ${loginRes.data}');

  final String? token = loginRes.statusCode == 200
      ? loginRes.data?['data']?['token'] as String?
      : null;

  if (token == null) {
    stdout.writeln('Login failed.');
    exit(1);
  }

  stdout.writeln('Token: OK');
  final auth = {'Authorization': 'Bearer $token'};

  stdout.writeln('\n=== STEP 2: GET blood-requests ===');
  final getRes = await dio.get(
    '$baseUrl/my-api/blood-requests',
    options: Options(headers: auth),
  );
  stdout.writeln('Status: ${getRes.statusCode}');
  stdout.writeln('Body: ${getRes.data}');

  stdout.writeln('\n=== STEP 3: Probe urgency candidates ===');
  final candidates = [
    'ROUTINE', 'CRITICAL', 'URGENT', 'EMERGENCY',
    'routine', 'critical', 'urgent', 'emergency',
    'Routine', 'Critical', 'Urgent', 'Emergency',
  ];

  for (final urgency in candidates) {
    final res = await dio.post(
      '$baseUrl/my-api/blood-requests',
      data: {
        'blood_type': 'O+',
        'urgency': urgency,
        'no_of_units': 1,
        'notes': 'probe_test',
        'hospital': {
          'name': 'Test Hospital',
          'address_text': 'Zagazig',
          'latitude': 30.5765383,
          'longitude': 31.5040656,
        },
      },
      options: Options(headers: auth),
    );
    final ok = res.statusCode != null && res.statusCode! < 422;
    final msg = ok ? 'ACCEPTED' : (res.data?['message'] ?? res.data ?? '');
    stdout.writeln('urgency="$urgency" -> HTTP ${res.statusCode} $msg');
    if (ok) {
      stdout.writeln('FOUND: "$urgency" is accepted!');
      stdout.writeln('Full response: ${res.data}');
      break;
    }
  }
}
