class ChatRoom {
  final String id;
  final String name;
  final String avatar;
  final String lastMessage;
  final String? time;
  final bool isOnline;

  ChatRoom({
    required this.id,
    required this.name,
    required this.avatar,
    required this.lastMessage,
    required this.time,
    required this.isOnline,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'].toString(),
      name: json['name'] ?? 'بدون اسم',
      avatar: json['avatar'] ?? '',
      lastMessage: json['last_message'] ?? '',
      time: json['time']?.toString(),
      isOnline: json['is_online'] ?? false,
    );
  }
}
