import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/DoctorDetailsModel.dart';
import '../models/doctor_model.dart';

class DoctorService {
  static const baseUrl = 'http://10.0.2.2:8000/api';
  // static const baseUrl = 'http://192.168.8.28:8000/api';


  static Future<List<Doctor>> fetchPopularDoctors() async {
    final url = Uri.parse('$baseUrl/doctors/popular');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      // print(data);
      return List<Doctor>.from(data.map((item) => Doctor.fromJson(item)));
    } else {
      throw Exception('فشل في تحميل الأطباء');
    }
  }

  static Future<DoctorDetailsModel?> getDoctor(int id) async {
    print("📡 [API] بدء جلب بيانات الدكتور بالـ ID: $id");

    final response = await http.get(Uri.parse("$baseUrl/doctors/$id"));
    print("📥 [API Response] status: ${response.statusCode}");
    print("📥 [API Response] body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      print("✅ [API Parsed Data] $data['schedules']");
      return DoctorDetailsModel.fromJson(data); // ✅ بيرجع موديل جاهز
    } else {
      print("❌ [API Error] فشل تحميل بيانات الدكتور");
      return null;
    }
  }



}
