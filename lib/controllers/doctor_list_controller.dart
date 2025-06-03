import 'package:get/get.dart';
import '../models/doctor_model.dart';

class DoctorListController extends GetxController {
  // متغيرات البحث والفلترة
  RxString searchQuery = ''.obs;
  RxList<Doctor> filteredDoctors = <Doctor>[].obs;
  RxBool hasActiveFilters = false.obs;

  // متغيرات الفلترة المتقدمة
  RxDouble minRating = 0.0.obs;
  RxDouble maxPrice = 100.0.obs; // تمثل نسبة مئوية 0-100%
  String currency = "ريال";

  List<Doctor> _originalDoctors = [];
  List<String> _availableSpecialties = [];

  @override
  void onInit() {
    // مراقبة تغيرات معايير الفلترة وتطبيقها تلقائياً
    ever(searchQuery, (_) => applyFilters());
    ever(minRating, (_) => applyFilters());
    ever(maxPrice, (_) => applyFilters());

    super.onInit();
  }

  void setDoctors(List<Doctor> doctors) {
    _originalDoctors = doctors;
    filteredDoctors.assignAll(doctors);

    // استخراج التخصصات المتاحة
    _extractSpecialties();
  }

  void _extractSpecialties() {
    final specialties = _originalDoctors
        .map((doctor) => doctor.specialization ?? 'غير محدد')
        .toSet()
        .toList();

    specialties.sort();
    _availableSpecialties = ['الكل'] + specialties;
  }

  List<String> get availableSpecialties => _availableSpecialties;

  void applyFilters() {
    List<Doctor> tempDoctors = List.from(_originalDoctors);

    // 1. تطبيق فلترة البحث النصي
    if (searchQuery.isNotEmpty) {
      tempDoctors = tempDoctors.where((doctor) {
        return doctor.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            (doctor.specialization?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false);
      }).toList();
    }

    // 2. تطبيق فلترة التقييم
    if (minRating.value > 0) {
      tempDoctors = tempDoctors.where((doctor) => doctor.rating >= minRating.value).toList();
    }

    // 3. تطبيق فلترة السعر (تحويل النسبة المئوية إلى قيمة فعلية)
    if (maxPrice.value < 100) {
      final maxPriceValue = maxPrice.value ; // تحويل 100% إلى 10000 دينار
      tempDoctors = tempDoctors.where((doctor) => doctor.pricePerHour <= maxPriceValue).toList();
    }

    // تحديث القائمة المفلترة
    filteredDoctors.assignAll(tempDoctors);

    // تحديث حالة الفلاتر النشطة
    updateActiveFiltersStatus();
  }

  void updateActiveFiltersStatus() {
    hasActiveFilters.value =
        searchQuery.isNotEmpty ||
            minRating.value > 0 ||
            maxPrice.value < 100;
  }

  void clearFilters() {
    searchQuery.value = '';
    minRating.value = 0;
    maxPrice.value = 100;

    applyFilters();
  }

  // دالة لحساب متوسط التقييمات (اختياري)
  double calculateAverageRating() {
    if (_originalDoctors.isEmpty) return 0.0;
    final totalRating = _originalDoctors.fold(0.0, (sum, doctor) => sum + doctor.rating);
    return totalRating / _originalDoctors.length;
  }

  // دالة للحصول على أعلى الأطباء تقييماً (اختياري)
  List<Doctor> getTopRatedDoctors(int count) {
    final sorted = List<Doctor>.from(_originalDoctors)
      ..sort((a, b) => b.rating.compareTo(a.rating));

    return sorted.take(count).toList();
  }
}