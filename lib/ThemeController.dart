import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ThemeController extends GetxController {
  // المتغير isDarkMode يكون قابل للمراقبة .obs
  RxBool isDarkMode = false.obs;

  // دالة تبديل الوضع بين الفاتح والليلي
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;

    // تغيير الثيم في التطبيق حسب قيمة isDarkMode
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
