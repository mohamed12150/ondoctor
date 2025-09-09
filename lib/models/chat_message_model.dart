class ChatMessage {
  final String text;
  final String time;
  final int senderId;


  ChatMessage({
    required this.text,
    required this.time,
    required this.senderId,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['message'] ?? '',
      time: json['created_at'] ?? '',
      senderId: json['sender_id'] ?? 0,
      // ← تأكد من الاسم حسب API
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': text,
      'created_at': time,
      'sender_id': senderId,
    };
  }

  // ✅ دالة مساعدة لمعرفة إذا الرسالة من المستخدم الحالي
  bool isMine(String currentUserId) {
    return senderId == currentUserId;
  }
}
