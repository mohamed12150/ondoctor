import 'package:get/get.dart';
import '../Screens/Auth/Login_page.dart';
import '../Screens/Auth/otp_page.dart';
import '../Screens/Auth/siginup.dart';
import '../Screens/category_page.dart';
import '../Screens/doctor_details_page.dart';
import '../Screens/home.dart';
import '../Screens/messages/chat_detail.dart';
import '../Screens/messages/chat_list.dart';
import '../Screens/profile/chronic_diseases_screen.dart';
import '../Screens/profile/profile_screen.dart';
import '../bindings/category_binding.dart';
import '../bindings/chat_detail_binding.dart';
import '../bindings/chat_room_binding.dart';
import '../bindings/doctor_details_binding.dart';
import '../bindings/medical_condition_binding.dart';
import '../bindings/profile_binding.dart';
import '../controllers/chat_detail_controller.dart';
import '../services/auth_service.dart';
final AuthService _auth = AuthService(); // ✅ عرّفها هنا


class AppRoutes {
  static final routes = [
    GetPage(name: '/', page: () => const Home()),
    GetPage(name: '/signup', page: () => const SignUpPage()),
    GetPage(name: '/login', page: () => const LoginPage()),
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
    GetPage(
      name: '/appointment/:id',
      page: () {
        final id = int.parse(Get.parameters['id']!); // جبت الـ id من الرابط
        return DoctorDetailsPage(doctorId: id);      // مررته للصفحة
      },
    ),


    GetPage(
      name: '/profile',
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: '/chronic-diseases',
      page: () => const ChronicDiseasesScreen(),
      binding: MedicalConditionBinding(),
    ),
    GetPage(
      name: '/chat',
      page: () => ChatListScreen(),
      binding: ChatRoomBinding(),
    ),

    GetPage(
      name: '/chat/:id',
      page: () {
        final id = Get.parameters['id']!;
        return ChatDetailScreen(chatId: id);
      },
      binding: BindingsBuilder(() {
        final id = Get.parameters['id']!;
        Get.lazyPut(() => ChatDetailController(id));
      }),
    ),
    GetPage(
      name: '/otp',
      page: () {
        final Map<String, dynamic> args =
            (Get.arguments as Map?)?.cast<String, dynamic>() ?? {};
        return OtpPage(
          identifier: (args['identifier'] as String?) ?? '', // إيميل/جوال
          auth: _auth,                                        // ✅ مرر السيرفس
        );
      },
    ),

  ];
}
