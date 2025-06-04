import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/auth_controller.dart';
import 'routes/app_routes.dart';
import 'Screens/home.dart';
import 'onboarding_page.dart';
import 'Screens/Auth/Login_page.dart'; // تأكد من المسار
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");



  Get.put(AuthController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> checkFirstSeenAndLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final seen = prefs.getBool('seen') ?? false;
    final token = prefs.getString('token');

    if (!seen) {
      return OnboardingPage(); // ⬅️ أول مرة يفتح التطبيق
    }

    if (token != null && token.isNotEmpty) {
      return const Home(); // ✅ عنده توكن
    } else {
      return const LoginPage(); // 🔒 ما مسجل دخول
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OnDoctor',
      initialRoute: '/',
      getPages: AppRoutes.routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
    );
  }
}
