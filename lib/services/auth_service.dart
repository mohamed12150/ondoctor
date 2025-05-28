import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:8000/api'; // 👈 تأكد ده شغال مع emulator

  /// تسجيل الدخول
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Accept': 'application/json'},
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['token'];

      // احفظ التوكن
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      // جلب بيانات المستخدم
      final user = await getUser(token);

      // احفظ الاسم
      await prefs.setString('userName', user['name']);
      await prefs.setString('email', user['email']);


      return {
        'success': true,
        'token': token,
        'user': user,
      };
    } else {
      final message = json.decode(response.body)['message'] ?? 'Login failed';
      throw Exception(message);
    }
  }

  /// تسجيل مستخدم جديد
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Accept': 'application/json'},
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      final token = data['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      final user = await getUser(token);
      await prefs.setString('userName', user['name']);

      return {
        'success': true,
        'token': token,
        'user': user,
      };
    } else {
      final message = json.decode(response.body)['message'] ?? 'Registration failed';
      throw Exception(message);
    }
  }

  /// جلب بيانات المستخدم عبر التوكن
  Future<Map<String, dynamic>> getUser(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('فشل في جلب بيانات المستخدم');
    }
  }

  /// تسجيل الخروج
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userName');
  }

  /// التحقق إذا كان المستخدم مسجل الدخول
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }
}
