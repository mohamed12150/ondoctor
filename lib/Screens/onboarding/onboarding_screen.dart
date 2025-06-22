
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'onboarding_controller.dart';
import 'widgets/top_half_circle.dart';
import 'widgets/page_indicator.dart';
import 'widgets/skip_button.dart';
import 'widgets/next_button.dart';


class OnboardingScreen extends StatelessWidget {
  final OnboardingController controller = Get.put(OnboardingController());

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Stack(
        children: [
          PageView.builder(
            controller: controller.pageController,
            itemCount: controller.pages.length,
            onPageChanged: (index) => controller.currentPage.value = index,
            itemBuilder: (context, index) {
              final page = controller.pages[index];
              return Column(
                children: [
                  TopHalfCircle(imagePath: page.imagePath),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Text(
                          page.title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          page.subtitle,
                          style: const TextStyle(
                            fontSize: 16, 
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        if (index == controller.pages.length - 1)
                          ElevatedButton(
                            onPressed: controller.finishOnboarding,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              "ابدأ الآن",
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
          
          // زر التالي (يظهر فقط عندما لا تكون في الصفحة الأخيرة)
          Obx(() => controller.currentPage.value < controller.pages.length - 1
              ? const NextButton()
              : const SizedBox.shrink()),

          const OnboardingSkipButton(),
          
          Obx(() => OnboardingPageIndicator(
  activeIndex: controller.currentPage.value,
  itemCount: controller.pages.length,
)),
        ],
      ),
    );
  }
}