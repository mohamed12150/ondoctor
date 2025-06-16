import 'package:get/get.dart';
import '../Screens/Auth/siginup.dart';
import '../Screens/category_page.dart';
import '../Screens/doctor_details_page.dart';
import '../Screens/home.dart';
import '../bindings/category_binding.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/', page: () => const Home()),
    GetPage(name: '/signup', page: () => const SignUpPage()),
    GetPage(name: '/home', page: () => const Home()),
    GetPage(
      name: '/categories',
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return CategoryPage(
          categoryId: args['categoryId'],
          categoryName: args['categoryName'],
        );
      },
      binding: CategoryBinding(),
    ),
    GetPage(name: '/appointment', page: () => DoctorDetailsPage()),
  ];
}
