import 'package:anonymous_chat/api/api_endpoint.dart';
import 'package:anonymous_chat/utils/shared_preferences_manager.dart';
import 'package:anonymous_chat/widget/chat_bubble_anonym.dart';
import 'package:flutter/material.dart';
import 'package:anonymous_chat/service/socket_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatAnonymScreen extends StatefulWidget {
  const ChatAnonymScreen({super.key});

  @override
  _ChatAnonymScreenState createState() => _ChatAnonymScreenState();
}

class _ChatAnonymScreenState extends State<ChatAnonymScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  SharedPreferencesManager prefManager = SharedPreferencesManager();
  late IO.Socket socket;
  String token = '';
  bool _isSearching = true;
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    initializeSocket();
  }

  Future<void> getToken() async {
    token = await prefManager.getToken();
  }

  Future<void> initializeSocket() async {
    await getToken();
    if (token.isNotEmpty) {
      connectToServer();
    }
  }

  void connectToServer() {
    socket = IO.io(ApiEndPoints.chatAnonym, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'extraHeaders': {'authorization': 'Bearer $token'},
    });
    socket.on('connect', (_) {});
    socket.on('disconnect', (_) {});
    socket.on('matching', (_) {
      print("Received matching event from server");
      setState(() {
        _isSearching = false;
      });
    });
    socket.on('partnerDisconnect', (_) {
      print("Partner disconnected");
      setState(() {
        _isSearching = true;
      });
    });
    socket.on('receiveMessage', (data) {
      setState(() {
        _messages.add({'content': data['message'], 'isMe': false});
      });
      _scrollToBottom();
    });
    socket.on('joinRoom', (data) {
      setState(() {
        _isSearching = false;
      });
      socket.emit('joinRoomAck', data[0]);
    });
    socket.on('sendMessage', (data) {
      setState(() {
        _messages.add({'content': data['message'], 'isMe': true});
      });
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    socket.disconnect();
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
      socket.emit('sendMessage', message);
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
            Navigator.pushNamedAndRemoveUntil(
                context, '/Home', (route) => false);
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
      body: _isSearching
          ? const Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Searching for a partner...',
                    style: TextStyle(fontSize: 18)),
              ],
            ))
          : GestureDetector(
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    color: Colors.black,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Type a message",
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5)),
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
