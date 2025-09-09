import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/chat_room_controller.dart';

class ChatListScreen extends StatelessWidget {
  final ChatRoomController controller = Get.find<ChatRoomController>();

  ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('محادثاتك')),

      body: Obx(() {
        if (controller.isLoading.value && controller.chats.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.chats.isEmpty) {
          return const Center(child: Text('لا توجد محادثات حتى الآن.'));
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!controller.isLoading.value &&
                !controller.isLastPage.value &&
                scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
              controller.fetchChatRooms(loadMore: true);
            }
            return false;
          },
          child: ListView.builder(
            itemCount: controller.chats.length + 1, // +1 لعرض مؤشر تحميل في النهاية
            itemBuilder: (context, index) {
              if (index == controller.chats.length) {
                if (controller.isLastPage.value) {
                  return const SizedBox.shrink(); // انتهت القائمة
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              }

              final chat = controller.chats[index];
              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      Get.toNamed('/chat/${chat.id}');
                    },
                    leading: CircleAvatar(
                      backgroundImage: chat.avatar.startsWith('http')
                          ? NetworkImage(chat.avatar)
                          : const AssetImage('assets/images/a.jpg') as ImageProvider,
                      radius: 24,
                    ),
                    title: Text(chat.name),
                    subtitle: Text(
                      chat.lastMessage.isNotEmpty ? chat.lastMessage : 'لا توجد رسائل بعد',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (chat.time != null && chat.time!.isNotEmpty)
                          Text(chat.time!, style: const TextStyle(fontSize: 12)),
                        if (chat.isOnline)
                          const Text('متصل', style: TextStyle(color: Colors.green, fontSize: 10)),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1, indent: 72, endIndent: 16),
                ],
              );
            },
          ),
        );
      }),
    );
  }
}
