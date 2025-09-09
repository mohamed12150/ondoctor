import 'package:get/get.dart';
import '../controllers/chat_detail_controller.dart';

class ChatDetailBinding extends Bindings {
  final String chatRoomId;
  ChatDetailBinding(this.chatRoomId);

  @override
  void dependencies() {
    Get.lazyPut(() => ChatDetailController(chatRoomId));
  }
}
