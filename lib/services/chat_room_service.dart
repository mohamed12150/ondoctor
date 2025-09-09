import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_room_model.dart';

class ChatRoomService {
  final Dio _dio = Dio(); // ✅ مثل ProfileService

  /// جلب غرف المحادثة
  Future<List<ChatRoom>> fetchChatRooms({int page = 1}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('التوكن غير موجود');

    final response = await _dio.get(
      'http://10.0.2.2:8000/api/chat-rooms?page=$page',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    final data = response.data['data']; // ✅ استخراج قائمة الدردشات
    return (data as List)
        .map((json) => ChatRoom.fromJson(json))
        .toList();
  }


/// ✅ طباعة البيانات في ملف داخل التخزين المؤقت
  // Future<void> _printToFile(dynamic data) async {
  //   try {
  //     final dir = await getTemporaryDirectory(); // من path_provider
  //     final file = File('${dir.path}/chat_rooms_log.txt');
  //     await file.writeAsString(data.toString());
  //     print('✅ تم حفظ البيانات في: ${file.path}');
  //   } catch (e) {
  //     print('❌ فشل في كتابة الملف: $e');
  //   }
  // }
}
