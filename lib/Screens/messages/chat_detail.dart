import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/chat_detail_controller.dart';
import '../../models/chat_room_model.dart';
import '../../controllers/chat_room_controller.dart';

class ChatDetailScreen extends StatelessWidget {
  final String chatId;

  ChatDetailScreen({super.key, required this.chatId});

  final ChatRoomController chatRoomController = Get.find();
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chat = chatRoomController.getRoomById(chatId)!;
    final controller = Get.find<ChatDetailController>();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: chat.avatar.startsWith('http')
                  ? NetworkImage(chat.avatar)
                  : const AssetImage('assets/images/a.jpg') as ImageProvider,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chat.name, style: const TextStyle(fontSize: 16)),
                Text(
                  chat.isOnline ? 'متصل' : 'غير متصل',
                  style: TextStyle(
                    fontSize: 12,
                    color: chat.isOnline ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                reverse: true,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[controller.messages.length - 1 - index];

                  // final currentUserId =  controller.chatMessageService.getCurrentUserId();
                  final isMe = msg.senderId == controller.currentUserId;

                  print('isMe: $isMe, senderId: ${msg.senderId}, currentUserId: ${controller.currentUserId}');



                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.deepPurple : Colors.grey[200],
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: const Radius.circular(12),
                          bottomLeft: Radius.circular(isMe ? 12 : 0),
                          bottomRight: Radius.circular(isMe ? 0 : 12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment:
                        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Text(
                            msg.text,
                            style: TextStyle(
                              fontSize: 15,
                              color: isMe ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            msg.time,
                            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            color: Colors.grey.shade100,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () {
                    // TODO: دعم المرفقات لاحقًا
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالتك...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    controller.sendMessage(textController.text);
                    textController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
