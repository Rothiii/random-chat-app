import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String content;
  final bool isMe; // true jika pesan dari saya, false jika dari anonym

  const ChatBubble({
    super.key,
    required this.content,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.66, // 2/3 screen width
        ),
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: isMe ? Colors.white : Colors.orange.shade300,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          content,
          style: TextStyle(
            color: isMe ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}
