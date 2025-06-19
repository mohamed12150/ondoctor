class Chat {
  final String id;
  final String doctorName;
  final String lastMessage;
  final String time;
  final bool isOnline;
  final String avatar;

  Chat({
    required this.id,
    required this.doctorName,
    required this.lastMessage,
    required this.time,
    required this.isOnline,
    required this.avatar,
  });
}