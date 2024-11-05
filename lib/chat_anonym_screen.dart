import 'package:anonymous_chat/widget/chat_bubble_bot.dart';
import 'package:flutter/material.dart';

class ChatAnonymScreen extends StatefulWidget {
  const ChatAnonymScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatAnonymScreenState createState() => _ChatAnonymScreenState();
}

class _ChatAnonymScreenState extends State<ChatAnonymScreen>
    with WidgetsBindingObserver {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom(){
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    });
  }

  void _sendMessage() {
    String message = _controller.text.trim();
    if (message.isNotEmpty) {

      _scrollToBottom();
      
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade300,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/Home');
          },
        ),
        title: const Text(
          "Room Chat With Anonym",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/image_anonym.png'),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          // Hapus fokus dari TextField untuk menutup keyboard
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            // Expanded(
            //   child: ListView.builder(
            //     controller: _scrollController,
            //     padding: const EdgeInsets.all(16.0),
            //     itemCount: _messages.length,
            //     itemBuilder: (context, index) {
            //       final message = _messages[index];
            //       return ChatBubble(
            //         content: message['content'] ?? '',
            //         role: message['role'] ?? 'unknown',
            //       );
            //     },
            //   ),
            // ),
            // Input field at the bottom
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Type a message",
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.5)),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) {
                        _sendMessage();
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
