import 'package:simple_flutter_reverb/simple_flutter_reverb.dart';
import 'package:simple_flutter_reverb/simple_flutter_reverb_options.dart';

class ReverbListener {
  final String roomId;
  final String token;
  late final SimpleFlutterReverb _reverb;

  ReverbListener({
    required this.roomId,
    required this.token,
  }) {

    final options = SimpleFlutterReverbOptions(
      scheme: "ws",
      host: "10.0.2.2", // localhost للمحاكي
      port: "8080",
      appKey: "vxyfcckah2znbfuuew46",
      authUrl: "http://10.0.2.2:8000/api/broadcasting/auth",
      authToken:  "Bearer $token",
      privatePrefix: "private-",
      usePrefix: true,
    );

    _reverb = SimpleFlutterReverb(options: options);
  }

  /// الاستماع للرسائل من القناة الخاصة
  void onMessage(Function(dynamic data) handler) {
    final channelName = 'private-chat-room$roomId';
    print(channelName);

    try {
      _reverb.listen((event) {
        print("📩 تم استلام حدث: ${event.event}");

        if (event.event == 'MessageSent') {
          print("📥 محتوى الرسالة: ${event.data}");
          handler(event.data);
        }
      }, channelName, isPrivate: true);
    } catch (e) {
      print("❌ فشل في الاستماع إلى WebSocket: $e");
    }
  }

  void close() {
    _reverb.close();
    print("🔌 تم إغلاق الاتصال بـ Reverb");
  }
}
