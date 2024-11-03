import 'package:anonymous_chat/service/llm_service.dart';
import 'package:anonymous_chat/widget/chat_bubble_bot.dart';
import 'package:flutter/material.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen>
    with WidgetsBindingObserver {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [{'role': 'assistant', 'content': 'Hai, apa yang bisa saya bantu hari ini? '}];
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final LlmService _llmService = LlmService();

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

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _sendMessage() async {
    String message = _controller.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        _messages.add({'role': 'user', 'content': message});
        _controller.clear();
      });

      _scrollToBottom();

      final botReply = await _llmService.sendMessage(_messages);
      if (botReply != null) {
        setState(() {
          _messages.add({'role': 'assistant', 'content': botReply});
        });
        _scrollToBottom();
      }

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
          "Now you are with bot",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/bot.jpg'),
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
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return ChatBubble(
                    content: message['content'] ?? '',
                    role: message['role'] ?? 'unknown',
                  );
                },
              ),
            ),
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
