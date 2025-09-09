import 'category_model.dart';
import 'schedule_model.dart';

class DoctorDetailsModel {
  final int id;
  final String name;
  final double pricePerHour;
  final String? profileImage;
  final double rating;
  final int reviewCount;
  final List<Category_detiales> categories;
  final List<Schedule> schedules;
  final String? dec;
  final String? email;
  final String? phone;
  final String? bio;

  DoctorDetailsModel({
    required this.id,
    required this.name,
    required this.pricePerHour,
    this.profileImage,
    required this.rating,
    required this.reviewCount,
    required this.categories,
    required this.schedules,
    this.dec,
    this.email,
    this.phone,
    this.bio,
  });

  factory DoctorDetailsModel.fromJson(Map<String, dynamic> json) {
    return DoctorDetailsModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'غير معروف',
      pricePerHour:
      double.tryParse(json['price_per_hour']?.toString() ?? '0') ?? 0.0,
      profileImage: json['avatar']?.toString(), // ✅ safe
      rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
      reviewCount: json['review_count'] ?? 0,
      dec: json['dec']?.toString(),
      email: json['email']?.toString(),
      // phone: json['phone']?.toString(),
      // bio: json['bio']?.toString(),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => Category_detiales.fromJson(e))
          .toList() ??
          [],
      schedules: (json['schedules'] as List<dynamic>?)
          ?.map((e) => Schedule.fromJson(e))
          .toList() ??
          [],
    );
  }

  String get fullImageUrl => profileImage ?? "";
}
