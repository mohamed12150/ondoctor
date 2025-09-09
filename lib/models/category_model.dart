import 'package:get/get.dart';

class Category {
  final int id;
  final String nameAr;
  final String nameEn;
  final String iconUrl;

  Category({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.iconUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
      iconUrl: json['icon_path'], // حسب اسم الحقل في API
    );
  }

  String getLocalizedName() {
    final lang = Get.locale?.languageCode ?? 'ar';
    return lang == 'en' ? nameEn : nameAr;
  }
}

class Category_detiales {
  final int id;
  final String? nameAr;
  final String? nameEn;
  final String? icon;

  Category_detiales({
    required this.id,
    this.nameAr,
    this.nameEn,
    this.icon,
  });

  factory Category_detiales.fromJson(Map<String, dynamic> json) {
    return Category_detiales(
      id: json['id'] ?? 0,
      nameAr: json['name_ar']?.toString(),
      nameEn: json['name_en']?.toString(),
      icon: json['icon']?.toString(), // ✅ null-safe
    );
  }
}

