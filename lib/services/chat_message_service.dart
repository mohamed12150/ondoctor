import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_message_model.dart';

class ChatMessageService {
  final Dio _dio = Dio();

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// ✅ جلب الرسائل
  Future<List<ChatMessage>> fetchMessages(String chatRoomId) async {
    final token = await _getToken();
    if (token == null) throw Exception('التوكن غير موجود');

    final response = await _dio.get(
      'http://10.0.2.2:8000/api/chat-rooms/$chatRoomId/messages',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    final data = response.data as List;
    return data.map((json) => ChatMessage.fromJson(json)).toList();
  }

  /// ✅ إرسال رسالة
  Future<ChatMessage> sendMessage(String chatRoomId, String text) async {
    final token = await _getToken();
    if (token == null) throw Exception('التوكن غير موجود');

    final response = await _dio.post(
      'http://10.0.2.2:8000/api/chat-rooms/$chatRoomId/messages',
      data: {'message': text},
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return ChatMessage.fromJson(response.data);
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception("❌ لا يوجد توكن محفوظ");
    }
    return token;
  }

  /// ✅ جلب رقم المستخدم الحالي
  Future<int> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = int.parse(prefs.getString('user_id') ?? '0');

    if (userId == null) {
      throw Exception("❌ لا يوجد user_id محفوظ");
    }
    return userId;
  }
}
