import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/category_controller.dart';
import '../services/category_service.dart';
import '../screens/category_page.dart';
import '../widgets/category_item.dart'; // ← تأكد أنك مستورد هذا

class HorizontalCategoryList extends StatelessWidget {
  final controller = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final categories = controller.categories;

      if (categories.isEmpty) {
        return const Text("لا توجد تصنيفات");
      }

      return SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            return CategoryItem(
              title: cat.name,
              iconWidget: cat.iconUrl != null
                  ? Image.network(cat.iconUrl!, height: 28, width: 28)
                  : const Icon(Icons.category),
              onTap: () {
                // Navigate to category details page
              },
            );
          },
        ),
      );
    });
  }
}

