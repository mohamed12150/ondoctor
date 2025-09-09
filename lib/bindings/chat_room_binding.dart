import 'package:get/get.dart';
import '../services/chat_room_service.dart';
import '../controllers/chat_room_controller.dart';

class ChatRoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatRoomController>(() => ChatRoomController());

    // هذا بديل لـ lazyPutAsync للنسخ القديمة
    // ChatRoomService.init().then((service) {
    //   Get.put(service);
    //   Get.put(ChatRoomController(service));
    // });
  }
}
// class CategoryBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<CategoryController>(() => CategoryController());
//   }
// }

