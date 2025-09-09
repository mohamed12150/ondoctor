import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:8000/api'; //  emulator
  // final String baseUrl = 'http://192.168.8.28:8000/api'; //  emulator
  Map<String, String> get _jsonHeaders => {'Accept': 'application/json'};

  /// تسجيل الدخول
  ///
  Future<Map<String, dynamic>> login(String email, String password) async {
    final r = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'password': password},
    );

    if (r.statusCode == 200) {
      final d = json.decode(r.body);
      final token = d['token'];
      final user = d['user'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await _saveSession(token, user);

      return {'success': true, 'token': token, 'user': user};
    }

    if (r.statusCode == 401) {
      final d = json.decode(r.body);
      if (d['status'] == 'otp_sent') {
        return {
          'success': false,
          'otp': true,
          'channel': d['channel'],
          'dest': d['dest'],
        };
      }
    }

    final msg = (json.decode(r.body)['message'] ?? 'Login failed').toString();
    throw Exception(msg);
  }

  /// تسجيل مستخدم جديد
  Future<Map<String, dynamic>> register(
      String name,
      String email,
      String password,
      ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Accept': 'application/json'},
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    // اطبع الرد الخام
    print('🔹 Response status: ${response.statusCode}');
    print('🔹 Raw body: ${response.body}');

    final r = json.decode(response.body);

    // اطبع الـ Map بعد الـ decode
    print('🔹 Decoded response: $r');

    if (response.statusCode == 200) {
      // ✅ حالة OTP
      if (r['status'] == 'otp_sent') {
        print('📩 OTP Sent → channel: ${r['channel']}, dest: ${r['dest']}');
        return {
          'otp': true,
          'channel': r['channel'],
          'dest': r['dest'],
          'message': r['message'] ?? 'تم إرسال رمز التحقق',
        };
      }

      // ✅ نجاح عادي
      print('✅ Registration success, data: $r');
      return {
        'otp': false,
        'success': true,
        'data': r,
      };
    }

    // ❌ أي حالة غير 200
    final message = r['message'] ?? 'Registration failed';
    print('❌ Error: $message');
    throw Exception(message);
  }






  /// جلب بيانات المستخدم عبر التوكن
  Future<Map<String, dynamic>> getUser(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
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

  Future<bool> verifyOtp(String identifier, String otp) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/verify-otp'),
      headers: {'Accept': 'application/json'},
      body: {'email': identifier, 'otp': otp},
    );

    if (res.statusCode == 200) {
      final data = json.decode(res.body) as Map<String, dynamic>;
      final token = data['token'] as String;
      final user = data['user'] as Map<String, dynamic>;
      await _saveSession(token, user); // ← تخزين التوكن + بيانات المستخدم
      return true;
    } else {
      throw Exception('فشل التحقق من الرمز   ');
    }

    // final msg = json.decode(res.body)['message'] ?? 'OTP غير صحيح أو منتهي';
    // throw Exception(msg);
  }

  Future<void> resendOtp(String identifier) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/resend-otp'),
      headers: {'Accept': 'application/json'},
      body: {'email': identifier},
    );

    if (res.statusCode == 200) return;

    final msg = json.decode(res.body)['message'] ?? 'تعذر إعادة الإرسال';
    throw Exception(msg);
  }

  Future<void> _saveSession(String token, Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('user_id', user['id'].toString());
    if (user['name'] != null) await prefs.setString('userName', user['name']);
    if (user['email'] != null) await prefs.setString('email', user['email']);
    if (user['phone'] != null)
      await prefs.setString('phone', user['phone'].toString());
    if (user['role'] != null)
      await prefs.setString('role', user['role'].toString());
  }
}
