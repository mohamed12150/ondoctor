import 'category_model.dart'; // أو أين ما يكون

class Doctor {
  final int id;
  final String name;
  final String? specialization;
  final double pricePerHour;
  final String? profileImage;
  final double rating;
  final int reviewCount;
  final List<Category> categories;

  Doctor({
    required this.id,
    required this.name,
    this.specialization,
    required this.pricePerHour,
    this.profileImage,
    required this.rating,
    required this.reviewCount,
    required this.categories,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      name: json['name'],
      specialization: json['specialization'],
      pricePerHour: double.tryParse(json['price_per_hour'].toString()) ?? 0.0,
      profileImage: json['profile_image'],
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
      reviewCount: json['review_count'],
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e))
          .toList() ??
          [],
    );
  }

  static const baseUrl = 'http://10.0.2.2:8000/api';

  String get fullImageUrl =>
      'http://10.0.2.2:8000/storage/${profileImage ?? ''}';


}