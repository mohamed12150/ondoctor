import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondoctor/Screens/messages/chat_data.dart';


class ChatController extends GetxController {
  var chats = <Chat>[].obs;
   var messages = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // بيانات وهمية مؤقتة
    chats.assignAll([
      Chat(
        id: '1',
        doctorName: 'د. أحمد سليمان',
        lastMessage: 'كيف حالك اليوم؟',
        time: '13:42',
        isOnline: true,
        avatar: 'assets/doctor1.png',
      ),
      Chat(
        id: '2',
        doctorName: 'د. سارة الأنصاري',
        lastMessage: 'الموعد تم تأكيده 👍',
        time: '11:20',
        isOnline: false,
        avatar: 'assets/doctor2.png',
      ),
    ]);
  }
 
 

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    messages.add({
      'fromUser': true,
      'text': text,
      'time': TimeOfDay.now().format(Get.context!),
    });

    //رد تلقائي(اختياري)
    Future.delayed(const Duration(milliseconds: 800), () {
      messages.add({
        'fromUser': false,
        'text': 'شكرًا على رسالتك! سأراجعها الآن.',
        'time': TimeOfDay.now().format(Get.context!),
      });
    });
  }

  Chat getChatById(String id) => chats.firstWhere((chat) => chat.id == id);
}