import 'package:get/get.dart';
import '../models/doctor_model.dart';
import '../services/doctor_service.dart';

class DoctorController extends GetxController {
  var popularDoctors = <Doctor>[].obs;
  var isLoading = false.obs;
  var selectedCategoryId = Rxn<int>(); // null = كل الأطباء

  @override
  void onInit() {
    fetchPopularDoctors();
    super.onInit();
  }

  void fetchPopularDoctors() async {
    isLoading(true);
    try {
      final doctors = await DoctorService.fetchPopularDoctors();
      popularDoctors.value = doctors;
      //print(doctors);
    } catch (e) {
      print('Error fetching doctors: $e');
    } finally {
      isLoading(false);
    }
  }

  List<Doctor> get filteredDoctors {
    if (selectedCategoryId.value == null) {
      return popularDoctors;
    }

    return popularDoctors.where((doctor) {
      return doctor.categories.any((cat) => cat.id == selectedCategoryId.value);
    }).toList();
  }

  void selectCategory(int? categoryId) {
    selectedCategoryId.value = categoryId;
  }
}
