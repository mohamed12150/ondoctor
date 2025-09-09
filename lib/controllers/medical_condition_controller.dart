import 'package:get/get.dart';
import '../models/MedicalCondition.dart';
import '../services/medical_condition_service.dart';

class MedicalConditionController extends GetxController {
  var conditions = <MedicalCondition>[].obs;
  var isLoading = false.obs;

  // تحميل الأمراض من السيرفر
  Future<void> fetchConditions() async {
    isLoading.value = true;
    try {
      final data = await MedicalConditionService.fetchConditions();
      conditions.assignAll(data);
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تحميل الأمراض: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // إضافة مرض جديد
  Future<void> addCondition(String name, String notes) async {
    try {
      await MedicalConditionService.addCondition(name, notes);
      await fetchConditions(); // إعادة تحميل القائمة بعد الإضافة
      Get.snackbar('نجاح', 'تمت إضافة  بنجاح'); // ✅ رسالة النجاح هنا
    } catch (e) {
      Get.snackbar('خطأ', 'فشل إضافة المرض: $e');
    }
  }


  // حذف مرض
  Future<void> deleteCondition(int id) async {
    try {
      await MedicalConditionService.deleteCondition(id);
      conditions.removeWhere((c) => c.id == id);
      Get.snackbar('نجاح', 'تم حذف المرض بنجاح'); // ✅ رسالة النجاح
    } catch (e) {
      Get.snackbar('خطأ', 'فشل حذف المرض: $e');
    }
  }


  // تعديل مرض
  Future<void> updateCondition({
    required int id,
    required String name,
    required String notes,
  }) async {
    try {
      await MedicalConditionService.updateCondition(
        id: id,
        name: name,
        notes: notes,
      );

      await fetchConditions(); // لتحديث القائمة بعد التعديل

      Get.snackbar('نجاح', 'تم تحديث المرض بنجاح'); // ✅ رسالة النجاح
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في التعديل: $e');
    }
  }


}
