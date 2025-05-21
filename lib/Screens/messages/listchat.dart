import 'package:flutter/material.dart';
import 'package:ondoctor/Screens/messages/messages_screen.dart';

class ChatSummary {
  final String doctorName;
  final String lastMessage;
  final String? image;
  final DateTime lastMessageTime;

  ChatSummary({
    required this.doctorName,
    required this.lastMessage,
    required this.image,
    required this.lastMessageTime,
  });
}

class ChatListScreen extends StatefulWidget {
  ChatListScreen({super.key});

  final List<ChatSummary> chats = [
    ChatSummary(
      doctorName: 'Dr. Smith',
      lastMessage: 'مرحباً كيف يمكنني مساعدتك؟',
      image: 'assets/images/a.jpg',
      lastMessageTime: DateTime.now().subtract(Duration(minutes: 5)),
    ),
    ChatSummary(
      doctorName: 'Dr. Jane',
      lastMessage: 'تم حجز موعدك يوم الإثنين',
      image: 'assets/images/a.jpg',
      lastMessageTime: DateTime.now().subtract(Duration(hours: 1, minutes: 10)),
    ),
  ];

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes} دقيقة مضت';
    if (diff.inHours < 24) return '${diff.inHours} ساعة مضت';
    return '${diff.inDays} يوم مضى';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('الدردشات'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 6,
        shadowColor: Colors.purple.shade300,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 216, 214, 214), const Color.fromARGB(255, 250, 249, 250)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FadeTransition(
          opacity: _animation,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: widget.chats.length,
            itemBuilder: (context, index) {
  final chat = widget.chats[index];
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(index / widget.chats.length, 1, curve: Curves.easeOut),
      ),
    ),
    child: Container(
      
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 19),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.black.withOpacity(0.2), 
      width: 1.2
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.shade100.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        leading: CircleAvatar(
          radius: 28,
          backgroundImage: AssetImage(chat.image ?? 'assets/images/a.jpg'),
          backgroundColor: Colors.purple.shade100,
        ),
        title: Text(
          chat.doctorName,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.purple.shade900,
          ),
        ),
        subtitle: Text(
          chat.lastMessage,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 14,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              
              _formatTime(chat.lastMessageTime),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.purple.shade600,
                shape: BoxShape.circle,
              ),
              child: const Text(
                '1',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatScreen(doctorName: chat.doctorName),
            ),
          );
        },
      ),
    ),
  );
}

          ),
        ),
      ),
    );
  }
}

