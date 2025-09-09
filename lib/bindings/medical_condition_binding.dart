// lib/bindings/medical_condition_binding.dart
import 'package:get/get.dart';
import '../controllers/medical_condition_controller.dart';

class MedicalConditionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MedicalConditionController());
  }
}
