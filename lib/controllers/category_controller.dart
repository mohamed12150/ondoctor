import 'package:get/get.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';

class CategoryController extends GetxController {
  var isLoading = true.obs;
  var categories = <Category>[].obs;

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  void fetchCategories() async {
    try {
      isLoading(true);
      final fetched = await CategoryService.fetchCategories();
      categories.assignAll(fetched);
      for (var cat in categories) {
        print('ID: ${cat.id}, Name: ${cat.name}, Icon: ${cat.iconUrl}');
      }
// مباشرة بدون map

    } catch (e) {
      Get.snackbar("خطأ", "فشل في جلب التصنيفات");
    } finally {
      isLoading(false);
    }
  }
}
