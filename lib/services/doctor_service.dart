import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/doctor_model.dart';

class DoctorService {
  static const baseUrl = 'http://127.0.0.1:8000/api';

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
