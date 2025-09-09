import 'category_model.dart'; // أو أين ما يكون

class Doctor {
  final int id;
  final String name;
  final double pricePerHour;
  final String? profileImage;
  final double rating;
  final int reviewCount;
  final List<Category> categories;
  final String? dec; // أضف هذا الحقل



  Doctor({
    required this.id,
    required this.name,
    required this.pricePerHour,
    this.profileImage,
    required this.rating,
    required this.reviewCount,
    required this.categories,
    this.dec, // أضف هنا

  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};

    return Doctor(
      id: json['id'],
      name: user['name'] ?? 'بدون اسم',
      pricePerHour: double.tryParse(json['price_per_hour'].toString()) ?? 0.0,
      profileImage: user['profile_image'], // قد يكون null وهذا طبيعي
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
      reviewCount: json['review_count'] ?? 0,
      dec: json['dec']?.toString(), // ✅ هنا تأكدنا أنه String أو null
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e))
          .toList() ?? [],
    );
  }



  static const baseUrl = 'http://10.0.2.2:8000/api';

  String get fullImageUrl =>
      'http://10.0.2.2:8000/storage/${profileImage ?? ''}';


}