import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/doctor_model.dart';

class DoctorService {
   static var baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8000/api'; // 👈 أخذ من .env

  static Future<List<Doctor>> fetchPopularDoctors() async {
    final url = Uri.parse('$baseUrl/doctors/popular');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return List<Doctor>.from(data.map((item) => Doctor.fromJson(item)));
    } else {
      throw Exception('فشل في تحميل الأطباء');
    }
  }
}
