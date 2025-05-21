class Message {
  final String sender;
  final String content;
  final Message? repliedTo;

  Message({
    required this.sender,
    required this.content,
    this.repliedTo,
  });
}
