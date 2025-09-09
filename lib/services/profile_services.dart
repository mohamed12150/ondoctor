import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dio/dio.dart' as dio;

class ProfileService {
  final Dio _dio = Dio();

  Future<void> updateProfile({
    required String name,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('التوكن غير موجود');

    final response = await _dio.put(
      'http://10.0.2.2:8000/api/profile/update',
      data: {'name': name, 'email': email},
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('فشل التحديث');
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null)
      throw Exception('التوكن غير موجود. يرجى تسجيل الدخول مجددًا.');

    try {
      final response = await _dio.post(
        'http://10.0.2.2:8000/api/profile/change-password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': confirmPassword,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      // ✅ حالة النجاح (200)
      if (response.statusCode == 200) {
        final message =
            response.data['message'] ?? 'تم تغيير كلمة المرور بنجاح';
        Get.snackbar('نجاح', message, backgroundColor: Colors.green.shade100);
      } else {
        throw Exception('فشل تغيير كلمة المرور (رمز غير متوقع).');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final status = e.response?.statusCode;

        // ⚠️ 422: أخطاء الفاليديشن
        if (status == 422) {
          final errors = e.response?.data['errors'];
          String errorMessage = 'حدث خطأ في البيانات:\n';

          if (errors != null && errors is Map) {
            errors.forEach((key, value) {
              errorMessage += "- ${value[0]}\n";
            });
          }

          throw Exception(errorMessage.trim());
        }

        // ⚠️ 400: كلمة المرور القديمة غير صحيحة
        if (status == 400) {
          final message = e.response?.data['message'] ?? 'خطأ غير معروف.';
          throw Exception(message);
        }

        // ⚠️ أخطاء أخرى
        throw Exception('خطأ غير متوقع: ${e.response?.data}');
      } else {
        throw Exception('تعذر الاتصال بالخادم.');
      }
    } catch (e) {
      rethrow;
    }
  }
  Future<String> updateAvatar(String filePath) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('التوكن غير موجود');

    final formData = dio.FormData.fromMap({
      'avatar': await dio.MultipartFile.fromFile(filePath, filename: 'avatar.jpg'),
    });

    final response = await _dio.post(
      'http://10.0.2.2:8000/api/profile/avatar',
      data: formData,
      options: Options(headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'multipart/form-data',
      }),
    );

    if (response.statusCode == 200) {
      final avatarUrl = response.data['avatar_url'];
      return avatarUrl; // ✅ رجّع رابط الصورة
    } else {
      throw Exception('فشل تحديث الصورة');
    }
  }



}
