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
      child: Stack(
        children: [
          // Efek neon glow
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: role == 'user'
                        ? Colors.blue.withOpacity(0.6)
                        : Colors.orange.withOpacity(0.6),
                    blurRadius: 20.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
            ),
          ),
          // Bubble utama dengan efek blur
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width *
                      0.66, // 2/3 screen width
                ),
                padding: const EdgeInsets.all(12.0),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: role == 'user'
                        ? [
                            Colors.blue.withOpacity(0.6),
                            Colors.blue.withOpacity(0.3)
                          ]
                        : [
                            Colors.orange.withOpacity(0.3),
                            Colors.orange.withOpacity(0.6),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: role == 'user'
                        ? Colors.blue.withOpacity(0.7)
                        : Colors.orange.withOpacity(0.7),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  content,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
