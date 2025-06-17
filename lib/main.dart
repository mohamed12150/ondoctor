
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/auth_controller.dart';
import 'routes/app_routes.dart';
import 'Screens/home.dart';
import 'onboarding_page.dart';

import 'Screens/Auth/Login_page.dart';
import 'controllers/theme_controller.dart'; // ⬅️ جديد
import 'translations.dart'; // ⬅️ جديد

// تأكد من المسار

  



void main() async {
  WidgetsFlutterBinding.ensureInitialized();





  Get.put(AuthController());
  Get.put(ThemeController()); // ⬅️ إضافة الكنترولر الخاص بالثيم

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> checkFirstSeenAndLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final seen = prefs.getBool('seen') ?? false;
    final token = prefs.getString('token');

    if (!seen) {
      return OnboardingPage();
    }

    if (token != null && token.isNotEmpty) {
      return const Home();
    } else {
      return const LoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'OnDoctor',
    
  translations: AppTranslation(), // ✅ تفعيل الترجمة
  locale: Get.locale ?? const Locale('en'), // ✅ ضبط اللغة الحالية
  fallbackLocale: const Locale('en'), // ✅ تحديد لغة احتياطية

// ✅ اللغة الاحتياطية
        theme: ThemeData.light().copyWith(
          textTheme: ThemeData.light().textTheme.apply(fontFamily: "Soudia"), // ⬅️ تعيين الخط
        ),
        darkTheme: ThemeData.dark().copyWith(
          textTheme: ThemeData.dark().textTheme.apply(fontFamily: "Soudia"),
        ), // ⬅️ تعيين الخط للوضع الداكن
        themeMode: themeController.themeMode.value, // ⬅️ التحكم في الوضع
        initialRoute: '/',
        getPages: AppRoutes.routes,
        home: FutureBuilder<Widget>(
          future: checkFirstSeenAndLogin(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return snapshot.data!;
            } else {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
    );
  }
}
