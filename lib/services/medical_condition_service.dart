import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/MedicalCondition.dart';

class MedicalConditionService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  static final Dio _dio = Dio();

  // جلب التوكن من SharedPreferences
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // ✅ جلب الأمراض المزمنة للمستخدم
  static Future<List<MedicalCondition>> fetchConditions() async {
    final token = await _getToken();
    if (token == null) throw Exception('المستخدم غير مسجل الدخول');

    final response = await _dio.get(
      '$baseUrl/chronic-conditions',
      options: Options(headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      }),
    );

    if (response.statusCode == 200) {
      final List data = response.data['data'];
      return data.map((json) => MedicalCondition.fromJson(json)).toList();
    } else {
      throw Exception('فشل في تحميل البيانات');
    }
  }

  // ✅ إضافة مرض جديد
  static Future<void> addCondition(String name, String notes) async {
    final token = await _getToken();
    if (token == null) throw Exception('المستخدم غير مسجل الدخول');

    await _dio.post(
      '$baseUrl/chronic-conditions',
      data: {'name': name, 'notes': notes},
      options: Options(headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      }),
    );
  }

  // ✅ حذف مرض
  static Future<void> deleteCondition(int id) async {
    final token = await _getToken();
    if (token == null) throw Exception('المستخدم غير مسجل الدخول');

    await _dio.delete(
      '$baseUrl/chronic-conditions/$id',
      options: Options(headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      }),
    );
  }

  // ✅ تعديل مرض
  static Future<void> updateCondition({
    required int id,
    required String name,
    required String notes,
  }) async {
    final token = await _getToken();
    if (token == null) throw Exception('المستخدم غير مسجل الدخول');

    await _dio.put(
      '$baseUrl/chronic-conditions/$id',
      data: {'name': name, 'notes': notes},
      options: Options(headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      }),
    );
  }
}
