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

      final res = await _authService.login(email, password);

      if (res['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', res['token']);
        await prefs.setString('user_id', res['user']['id'].toString());
        await prefs.setString('role', res['user']['role'].toString());
        Get.snackbar('Welcome', 'Logged in successfully');
        Get.offAllNamed('/home');
        return;
      }

      if (res['otp'] == true) {
        Get.snackbar('تحقق مطلوب', 'تم إرسال رمز التحقق');
        Get.toNamed('/otp', arguments: {
          'identifier': email,
          'password': password, // عشان بعد التحقق نعيد محاولة الدخول تلقائياً
          'channel': res['channel'],
          'dest': res['dest'],
        });
        return;
      }

      Get.snackbar('فشل تسجيل الدخول', 'حاول مرة أخرى');
    } catch (e) {
      Get.snackbar('فشل تسجيل الدخول', e.toString(),
          snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 3));
    } finally {
      isLoading.value = false;
    }
  }


  // تسجيل مستخدم جديد
  Future<void> register(String name, String email, String password) async {
    try {
      isLoading.value = true;

      final res = await _authService.register(name, email, password);
      print(res);

      if (res['otp'] == true) {
        // ✅ حالة OTP
        Get.snackbar('تحقق مطلوب', 'تم إرسال رمز التحقق');
        Get.toNamed('/otp', arguments: {
          'identifier': email,
          'password': password, // لإعادة المحاولة بعد التحقق
          'channel': res['channel'],
          'dest': res['dest'],
        });
        return;
      }

      if (res['success'] == true) {
        // ✅ نجاح عادي
        Get.snackbar('تم التسجيل بنجاح', 'مرحباً بك!');
        // ممكن تخزن التوكن أو تروح للصفحة الرئيسية
        // final prefs = await SharedPreferences.getInstance();
        // await prefs.setString('token', res['data']['token']);
        Get.offAllNamed('/home');
        return;
      }

      // ❌ لو ما كان OTP ولا نجاح
      Get.snackbar('فشل انشاء الحساب', 'حاول مرة أخرى');
    } catch (e) {
      Get.snackbar('Register Failed', e.toString());
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

  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

}
