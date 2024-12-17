import 'dart:ui';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String content;
  final String role; // 'user' untuk pesan dari user, 'assistant' untuk bot

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
          maxWidth:
              MediaQuery.of(context).size.width * 0.66, // 2/3 screen width
        ),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          gradient: LinearGradient(
            colors: role == 'user'
                ? [
                    Colors.blue.withOpacity(0.6),
                    Colors.blue.withOpacity(0.3),
                  ]
                : [
                    Colors.orange.withOpacity(0.3),
                    Colors.orange.withOpacity(0.6),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: role == 'user'
                  ? Colors.blue.withOpacity(0.7)
                  : Colors.orange.withOpacity(0.7),
              blurRadius: 20.0, // Ukuran glow
              spreadRadius: 2.0, // Glow tipis di sekitar bubble
              offset: const Offset(0, 0),
            ),
          ],
          border: Border.all(
            color: role == 'user'
                ? Colors.blue.withOpacity(0.7)
                : Colors.orange.withOpacity(0.7),
            width: 1.5,
          ),
        ),
        child: Text(
          content,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
