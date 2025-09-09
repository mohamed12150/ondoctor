import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';

class OtpController {
  final AuthService auth;
  final String identifier; // إيميل أو رقم جوال

  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<int> secondsLeft = ValueNotifier(60);
  final ValueNotifier<bool> canResend = ValueNotifier(false);

  Timer? _timer;

  OtpController({required this.auth, required this.identifier}) {
    _startTimer();
  }

  void _startTimer() {
    secondsLeft.value = 60;
    canResend.value = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft.value <= 1) {
        t.cancel();
        canResend.value = true;
      } else {
        secondsLeft.value -= 1;
      }
    });
  }

  Future<bool> submitOtp(String otp) async {
    if (otp.trim().isEmpty) {
      Get.snackbar('OTP Error', 'الرجاء إدخال الرمز');
      return false;
    }
    try {
      isLoading.value = true;
      final ok = await auth.verifyOtp(identifier, otp.trim());
      return ok;
    } catch (e) {
      // 👈 هنا نفس أسلوبك
      Get.snackbar('OTP Failed', e.toString().replaceFirst('Exception: ', ''));
      return false;
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> resend() async {
    if (!canResend.value) return;
    try {
      isLoading.value = true;
      await auth.resendOtp(identifier);
      _startTimer();
    } finally {
      isLoading.value = false;
    }
  }

  void dispose() {
    _timer?.cancel();
    isLoading.dispose();
    secondsLeft.dispose();
    canResend.dispose();
  }
}
