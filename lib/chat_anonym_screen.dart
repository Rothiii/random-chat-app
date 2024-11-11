import 'package:anonymous_chat/widget/chat_bubble_anonym.dart';
import 'package:flutter/material.dart';
import 'package:anonymous_chat/service/socket_service.dart';

class ChatAnonymScreen extends StatefulWidget {
  const ChatAnonymScreen({super.key});

  @override
  _ChatAnonymScreenState createState() => _ChatAnonymScreenState();
}

class _ChatAnonymScreenState extends State<ChatAnonymScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final SocketService _socketService = SocketService();
  bool _isSearching = true;
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _socketService.connect();

    _socketService.socket?.on('matching', (_) {
      setState(() {
        _isSearching = false;
      });
    });

    _socketService.socket?.on('partner_left', (_) {
      Navigator.pushReplacementNamed(context, '/Home');
    });

    _socketService.socket?.on('receiveMessage', (data) {
      setState(() {
        _messages.add({'content': data['message'], 'isMe': false});
      });
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _socketService.disconnect();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
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
      setState(() {
        _messages.add({'content': message, 'isMe': true});
      });
      _socketService.sendMessage(message);
      print('Sent: $message');
      _controller.clear();
      _scrollToBottom();
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
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return ChatBubble(
                    content: message['content'] ?? '',
                    isMe: message['isMe'] ?? false,
                  );
                },
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              color: Colors.black,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Type a message",
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.5)),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _sendMessage(),
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
