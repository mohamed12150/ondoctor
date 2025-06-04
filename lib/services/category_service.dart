import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
class CategoryService {

  static   var baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8000/api'; // 👈 أخذ من .env




  // category_service.dart
  static Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['data'])
          .map((e) => Category.fromJson(e))
          .toList();
    } else {
      throw Exception('فشل في جلب التصنيفات');
    }
  }

}
