import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String content;
  final String role; // true jika pesan dari user, false jika dari bot/anonym

  const ChatBubble({
    super.key,
    required this.content,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: role == 'user' ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.66, // 2/3 screen width
        ),
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: role == 'user' ? Colors.white : Colors.orange.shade300,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Text(
          content,
          style: TextStyle(
            color: role == 'user' ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}
