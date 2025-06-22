import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../onboarding_controller.dart';

class NextButton extends StatelessWidget {
  const NextButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();

    return Positioned(
      bottom: 90,
      right: 150,

      child: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          controller.pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        },
        child: const Icon(Icons.arrow_forward, color: Colors.deepPurple),
      ),
    );
  }
}
