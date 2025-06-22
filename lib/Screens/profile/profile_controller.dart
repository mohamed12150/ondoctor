import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ondoctor/Screens/profile/chronic_diseases_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';


class ProfileController extends ChangeNotifier {
  String? userName;
  String? email;
  File? profileImage;

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('userName') ?? '';
    email = prefs.getString('email') ?? '';
    notifyListeners();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      notifyListeners();
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
      builder: (context) => AlertDialog(
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
}