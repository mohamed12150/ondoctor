import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screens/Auth/Login_page.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  var isLoading = false.obs;

  // تسجيل الدخول
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;

      final data = await _authService.login(email, password);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);

      Get.snackbar(' Welcome', 'Logged in successfully');
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar(
        ' فشل تسجيل الدخول',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // تسجيل مستخدم جديد
  Future<void> register(String name, String email, String password) async {
    try {
      isLoading.value = true;

      final data = await _authService.register(name, email, password);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);

      Get.snackbar(' Registered', 'Account created');
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar(' Register Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // تسجيل الخروج
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Get.offAllNamed('/');
  }

  // التحقق من التوكن عند التشغيل
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }
  Future<bool> checkIfLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      // مش مسجل دخول
      Get.snackbar("🔒 تنبيه", "يجب تسجيل الدخول أولًا");
      Get.to(() => const LoginPage());
      return false;
    }

    return true; // مسجل دخول
  }

}
