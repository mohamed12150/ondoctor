import 'package:get/get.dart';
import '../services/chat_room_service.dart';
import '../models/chat_room_model.dart';

class ChatRoomController extends GetxController {
  final ChatRoomService chatRoomService = ChatRoomService();

  final chats = <ChatRoom>[].obs;
  final isLoading = false.obs;
  final isLastPage = false.obs;
  final page = 1.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchChatRooms(); // تحميل الصفحة الأولى
  }

  /// تحميل الدردشات - مع دعم تحميل إضافي
  Future<void> fetchChatRooms({bool loadMore = false}) async {
    if (isLoading.value || isLastPage.value) return;

    isLoading.value = true;
    errorMessage.value = null;

    try {
      final result = await chatRoomService.fetchChatRooms(page: page.value);

      if (result.isEmpty) {
        isLastPage.value = true; // لا مزيد من البيانات
      } else {
        if (loadMore) {
          chats.addAll(result); // تحميل إضافي
        } else {
          chats.assignAll(result); // أول تحميل
        }
        page.value += 1; // انتقل للصفحة التالية
      }
    } catch (e) {
      errorMessage.value = 'حدث خطأ أثناء تحميل المحادثات';
      print('❌ Error in ChatRoomController: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// جلب غرفة محددة بالمعرّف
  ChatRoom? getRoomById(String id) {
    return chats.firstWhereOrNull((room) => room.id == id);
  }
}
