import 'package:get/get.dart';
import '../Screens/Auth/Login_page.dart';
import '../Screens/Auth/siginup.dart';
import '../Screens/home.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/', page: () => const LoginPage()),
    GetPage(name: '/signup', page: () => const SignUpPage()),
    GetPage(name: '/home', page: () => const Home()),
  ];
}
