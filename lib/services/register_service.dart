import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterService {

  static const String baseUrl = 'http://192.168.8.80:8000/api'; // Emulator لـ Laravel


  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    required String dateOfBirth,
  }) async {
    final url = Uri.parse('$baseUrl/register');

    final response = await http.post(
      url,
      headers: {'Accept': 'application/json'},
      body: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': confirmPassword,
        'date_of_birth': dateOfBirth,
      },
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception(json.decode(response.body)['message'] ?? 'Registration failed');
    }
  }
}
