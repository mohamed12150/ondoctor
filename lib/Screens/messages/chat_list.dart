import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondoctor/Screens/messages/chat_detail.dart';
import 'package:ondoctor/Screens/messages/chat_controller.dart';


class ChatListScreen extends StatelessWidget {
  final ChatController controller = Get.put(ChatController());

  ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('محادثاتك')),
  body: Obx(() => ListView.builder(
    itemCount: controller.chats.length,
    itemBuilder: (context, index) {
      final chat = controller.chats[index];
      return Column(
        children: [
          ListTile(
            leading: CircleAvatar(backgroundImage: AssetImage(chat.avatar)),
            title: Text(chat.doctorName),
            subtitle: Text(chat.lastMessage),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(chat.time, style: const TextStyle(fontSize: 12)),
                if (chat.isOnline)
                  const Text('متصل', style: TextStyle(color: Colors.green, fontSize: 10)),
              ],
            ),
            onTap: () => Get.to(() => ChatDetailScreen(chatId: chat.id)),
          ),
          const Divider(height: 1, thickness: 1, indent: 72, endIndent: 16),
        ],
      );
    })),
    );
  }
}