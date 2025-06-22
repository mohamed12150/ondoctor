import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../onboarding_controller.dart';

class OnboardingSkipButton extends StatelessWidget {
  const OnboardingSkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      right: 20,
      child: TextButton(
        onPressed: () {
          Get.find<OnboardingController>().finishOnboarding();
        },
        child: const Text(
          "تخطي",
          style: TextStyle(color: Colors.deepPurple, fontSize: 16),
        ),
      ),
    );
  }
}
