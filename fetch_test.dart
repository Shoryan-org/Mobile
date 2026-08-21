import 'package:dio/dio.dart';
import 'dart:math';

void main() async {
  final dio = Dio(BaseOptions(
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    validateStatus: (status) => true,
  ));
  
  try {
    final email = 'test${Random().nextInt(100000)}@test.com';
    print('Registering $email');
    final regRes = await dio.post('https://shoryan-api.vercel.app/my-api/auth/register', data: {
      'name': 'Test User',
      'email': email,
      'password': 'password123',
      'password_confirmation': 'password123',
      'phone': '01${Random().nextInt(900000000) + 10000000}', // Egyptian format probably
      'blood_type': 'O+',
      'address': {
        'latitude': 0.0,
        'longitude': 0.0,
        'address_text': 'Test',
      },
    });
    
    print('Reg res: ${regRes.data}');
    String token = regRes.data['data']['token'];
    
    print('Token: $token');
    
    final urgencies = ['CRITICAL', 'critical', 'URGENT', 'urgent', 'EMERGENCY', 'emergency', 'ROUTINE', 'routine', 'NORMAL', 'normal', 'HIGH', 'high', 'LOW', 'low'];
    
    for (final urgency in urgencies) {
      print('Testing urgency: $urgency');
      final postRes = await dio.post('https://shoryan-api.vercel.app/my-api/blood-requests', 
        data: {
          'blood_type': 'O+',
          'urgency': urgency,
          'no_of_units': 1,
          'notes': 'test',
          'hospital': {
            'name': 'test',
            'address_text': 'test',
            'latitude': 0.0,
            'longitude': 0.0,
          }
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (postRes.statusCode != 422) {
         print('POST $urgency Success! Code: ${postRes.statusCode}, Data: ${postRes.data}');
         break; // found one that works? Or check them all.
      } else {
         print('POST $urgency failed 422');
      }
    }

  } catch (e) {
    print(e);
  }
}
