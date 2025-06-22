import 'package:flutter/material.dart';


class OnboardingPageIndicator extends StatelessWidget {
  final int activeIndex;
  final int itemCount;

  const OnboardingPageIndicator({
    super.key,
    required this.activeIndex,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          itemCount,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 5),
            width: activeIndex == index ? 16 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: activeIndex == index ? Colors.white : Colors.white54,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}