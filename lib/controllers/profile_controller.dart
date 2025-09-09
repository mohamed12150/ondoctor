import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ondoctor/Screens/profile/chronic_diseases_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ondoctor/services/profile_service.dart';
import '../models/user_model.dart';
import '../services/profile_services.dart';

class ProfileController extends GetxController {
  String? userName;
  String? email;
  File? profileImage;
  String? avatarUrl; // ✅ هنا تضيف المتغير

  final ProfileService _profileService = ProfileService();


  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();

    for (var key in allKeys) {
      print('$key => ${prefs.get(key)}');
    }
    userName = prefs.getString('userName') ?? '';
    email = prefs.getString('email') ?? '';
    avatarUrl = prefs.getString('avatar_url') ?? ''; // ✅ تحميل رابط الصورة المحفوظ
    // print(avatarUrl);
    print('loaded username: $userName');
    print('loaded email: $email');


    update(); // ✅ تحدث الواجهة تلقائيًا
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // profileImage = File(pickedFile.path);
      await uploadAvatar(pickedFile.path); // ✅ ارفع الصورة مباشرة

      update(); // ✅ تحدث الواجهة تلقائيً
    }
  }

  void changeAvatar() {
    pickImage();
  }

  void openChronicDiseasesScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ChronicDiseasesScreen()),
    );
  }

  void showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('تأكيد تسجيل الخروج'),
            content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('لا'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('token');
                  await prefs.remove('userName');
                  await prefs.remove('email');
                  Get.snackbar(
                    'تم تسجيل الخروج',
                    'يرجى تسجيل الدخول مرة أخرى',
                    colorText: Colors.black,
                  );
                  Get.offAllNamed('/login');
                },
                child: const Text('نعم'),
              ),
            ],
          ),
    );
  }

  Future<void> updateProfileData({
    required String name,
    required String email,
  }) async {
    try {
      await _profileService.updateProfile(name: name, email: email);

      // تحديث البيانات محليًا بعد نجاح التحديث في السيرفر
      this.userName = name;
      this.email = email;

      // تحديث الواجهة
      update();

      // (اختياري) تحديث SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', name);
      await prefs.setString('email', email);
    } catch (e) {
      rethrow; // عشان تتعالج في الواجهة بالـ snackbar مثلاً
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,

  }) async {
    try {
      await _profileService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,

      );
    } catch (e) {
      rethrow;
    }
  }
  Future<void> uploadAvatar(String filePath) async {
    try {
      final avatarUrlFromServer = await _profileService.updateAvatar(filePath);

      // احفظه في المتغير وفي SharedPreferences
      avatarUrl = avatarUrlFromServer;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('avatar_url', avatarUrl!);
      profileImage = File(filePath);

      update(); // تحديث الواجهة
      Get.snackbar('تم', 'تم تحديث الصورة بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', e.toString(), backgroundColor: Colors.red.shade100);
    }
  }




}
