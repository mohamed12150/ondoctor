import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondoctor/Screens/onboarding/model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;
  
  final List<OnboardingPageModel> pages = [
    OnboardingPageModel(
      title: "مرحبًا بك في Doctor",
      subtitle: "منصة استشارات طبية سهلة وآمنة",
      imagePath: "assets/animations/4.json",
    ),
    OnboardingPageModel(
      title: "احجز بسهولة",
      subtitle: "اختر طبيبك واحجز في ثوان",
      imagePath: "assets/animations/aoSjpTo6Io.json",
    ),
    OnboardingPageModel(
      title: "سجل طبي آمن",
      subtitle: "راجع محادثاتك السابقة وتوصيات الأطباء في ملف طبي خاص",
      imagePath: "assets/animations/mPpBkH4aIe.json",
    ),
  ];

  Future<void> finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("seen", true);
    Get.offAllNamed('/home');
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}