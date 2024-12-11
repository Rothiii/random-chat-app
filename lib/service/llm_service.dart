import 'dart:convert';
import 'package:anonymous_chat/api/api_endpoint.dart';
import 'package:http/http.dart' as http;

class LlmService {
  final String baseUrl = ApiEndPoints.chatBot;

  Future<String?> sendMessage(List<Map<String, String>> message) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "model": "gemma-2-9b-it-q4_k_m",
        "messages": message,
        "stream": false // Set to true if using streaming
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      return null;
    }
  }
}