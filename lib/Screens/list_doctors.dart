import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/doctor_model.dart';
import '../controllers/doctor_list_controller.dart';

class DoctorsListPage extends StatelessWidget {
  final List<Doctor> doctors;
  final DoctorListController controller = Get.put(DoctorListController());

  DoctorsListPage({super.key, required this.doctors}) {
    controller.setDoctors(doctors);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "قائمة الأطباء",
          style: TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.deepPurple),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showAdvancedFilterDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // حقل البحث
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "ابحث بالاسم أو التخصص...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => controller.searchQuery.value = value,
            ),
          ),

          // شريط الفلترة النشطة
          Obx(() => controller.hasActiveFilters.value
              ? _buildActiveFiltersBar()
              : const SizedBox.shrink()),

          // قائمة الأطباء
          Expanded(
            child: Obx(() {
              final filteredDoctors = controller.filteredDoctors;

              if (filteredDoctors.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset("assets/images/no_results.jpg", height: 150),
                      const SizedBox(height: 20),
                      const Text(
                        "لا يوجد أطباء مطابقين لبحثك",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: controller.clearFilters,
                        child: const Text("مسح الفلترة"),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: filteredDoctors.length,
                itemBuilder: (context, index) {
                  final doctor = filteredDoctors[index];
                  return _buildDoctorCard(doctor);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFiltersBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Obx(() {
            final filters = [];
            if (controller.searchQuery.isNotEmpty) filters.add("بحث: ${controller.searchQuery.value}");
            if (controller.minRating.value > 0) filters.add("تقييم ≥ ${controller.minRating.value.toStringAsFixed(1)}");
            if (controller.maxPrice.value < 100) filters.add("سعر ≤ ${(controller.maxPrice.value ).toInt()} ${controller.currency}");

            return Expanded(
              child: Text(
                filters.join(" | "),
                style: const TextStyle(color: Colors.deepPurple),
              ),
            );
          }),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: controller.clearFilters,
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(Doctor doctor) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/appointment/${doctor.id}');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // صورة الطبيب
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: doctor.profileImage != null && doctor.profileImage!.isNotEmpty
                  ? NetworkImage(doctor.fullImageUrl)
                  : const AssetImage("assets/images/default_doctor.png") as ImageProvider,
            ),
            const SizedBox(width: 16),

            // معلومات الطبيب
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor.categories.isNotEmpty
                        ? (Get.locale?.languageCode == 'en'
                        ? doctor.categories.first.nameEn
                        : doctor.categories.first.nameAr)
                        : 'غير محدد',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "${doctor.rating} (${doctor.reviewCount} تقييم)",
                        style: const TextStyle(fontSize: 13),
                      ),
                      const Spacer(),
                      Text(
                        "${doctor.pricePerHour} ${controller.currency}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showAdvancedFilterDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // العنوان وزر الإغلاق
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "الفلترة المتقدمة",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: Get.back,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // فلترة التقييم
              Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        "الحد الأدنى للتقييم",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      Text(
                        "${controller.minRating.value.toStringAsFixed(1)} نجوم",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 6,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
                    ),
                    child: Slider(
                      min: 0,
                      max: 5,
                      divisions: 10,
                      value: controller.minRating.value,
                      activeColor: Colors.deepPurple,
                      inactiveColor: Colors.grey.shade300,
                      onChanged: (value) => controller.minRating.value = value,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("0", style: TextStyle(fontSize: 12)),
                      Text("5", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              )),

              const SizedBox(height: 24),

              // فلترة السعر
              Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.attach_money, color: Colors.deepPurple, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        "الحد الأقصى للسعر",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      Text(
                        "${(controller.maxPrice.value).toInt()} ${controller.currency}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 6,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
                    ),
                    child: Slider(
                      min: 0,
                      max: 100,

                      value: controller.maxPrice.value,
                      activeColor: Colors.green,
                      inactiveColor: Colors.grey.shade300,
                      onChanged: (value) => controller.maxPrice.value = value,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("0", style: TextStyle(fontSize: 12)),
                      Text("100%", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              )),

              const SizedBox(height: 24),

              // أزرار التطبيق والمسح
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: controller.clearFilters,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.red.shade300),
                      ),
                      child: Text(
                        "مسح الفلترة",
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.applyFilters();
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "تطبيق الفلترة",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}