import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/chat_message_model.dart';
import '../services/chat_message_service.dart';
import '../services/socket_service.dart';

class ChatDetailController extends GetxController {
  final String chatRoomId;
  final ChatMessageService chatMessageService = ChatMessageService();

  final messages = <ChatMessage>[].obs;
  final isLoading = false.obs;
  final isSending = false.obs;

  late final ReverbListener reverbListener;
  late int currentUserId;
// ✅ أضف هذا


  ChatDetailController(this.chatRoomId);

  @override
  void onInit() async {
    super.onInit();
    currentUserId = await chatMessageService.getCurrentUserId();
    await loadMessages();
    initWebSocket();


  }

  Future<void> loadMessages() async {
    try {
      isLoading.value = true;
      final fetched = await chatMessageService.fetchMessages(chatRoomId);
      messages.assignAll(fetched);
    } catch (e) {
      print('❌ فشل في تحميل الرسائل: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    try {
      isSending.value = true;
      final newMsg = await chatMessageService.sendMessage(chatRoomId, text);
      messages.add(newMsg); // ✅ لا تكرر الإضافة إن كانت WebSocket تُرجع نفس الرسالة
    } catch (e) {
      print('❌ فشل في إرسال الرسالة: $e');
    } finally {
      isSending.value = false;
    }
  }

  void initWebSocket() async {
    final token = await chatMessageService.getToken();
    reverbListener = ReverbListener(
      roomId: chatRoomId,
      token: token,
    );

    reverbListener.onMessage((data) {
      print('📥 تم استقبال رسالة جديدة عبر WebSocket: $data');

      final newMessage = ChatMessage.fromJson(data);

      // ✅ تأكد من عدم تكرار الرسالة إذا كانت موجودة
      final alreadyExists = messages.any((msg) => msg.text == newMessage.text && msg.time == newMessage.time);
      if (!alreadyExists) {
        messages.add(newMessage);
      }
    });
  }

  @override
  void onClose() {
    reverbListener.close();
    super.onClose();
  }
}
