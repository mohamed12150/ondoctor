import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterService {

  static const String baseUrl = 'http://10.0.2.2:8000/api';  // Emulator لـ Laravel
  // static const String baseUrl = 'http://192.168.8.28:8000/api';  // Emulator لـ Laravel


  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    required String dateOfBirth,
    required String role,
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
        'role': role,
      },
    );

    print("Sending role as: $role (${role.runtimeType})");
    print("Response status: ${response.statusCode}");
    print("Raw body: ${response.body}");

    final r = json.decode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return r;
    } else {
      final message = r['message'] ?? 'Registration failed';
      throw Exception(message);
    }
  }
}