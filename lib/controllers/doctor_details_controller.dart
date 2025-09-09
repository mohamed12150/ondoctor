import 'package:get/get.dart';
import '../models/DoctorDetailsModel.dart';
import '../services/doctor_service.dart';

class DoctorDetailsController extends GetxController {
  var doctor = Rxn<DoctorDetailsModel>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    // ✅ نجيب الـ id من الـ route parameters
    final idParam = Get.parameters['id'];

    if (idParam != null) {
      final id = int.tryParse(idParam);
      if (id != null) {
        fetchDoctor(id);
      } else {
        print("⚠️ [Controller] الـ id مش رقم صحيح: $idParam");
      }
    } else {
      print("⚠️ [Controller] مافي أي id في الراوت");
    }
  }

  Future<void> fetchDoctor(int id) async {
    isLoading(true);
    try {
      print("🎯 [Controller] بدء جلب الدكتور ID=$id");
      final DoctorDetailsModel? data = await DoctorService.getDoctor(id); // ✅ نوع صريح
      if (data != null) {
        doctor.value = data;
        print("✅ [Controller] تم حفظ بيانات الدكتور: ${data.name}");
      } else {
        print("⚠️ [Controller] البيانات فاضية!");
      }
    } catch (e, st) {
      print("❌ Error fetching doctor details: $e");
      print("📌 StackTrace: $st");
    } finally {
      isLoading(false);
    }
  }

}
