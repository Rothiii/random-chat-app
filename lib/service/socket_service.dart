import 'dart:convert';
import 'package:anonymous_chat/api/api_endpoint.dart';
import 'package:anonymous_chat/utils/shared_preferences_manager.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';

class SocketService {
  IO.Socket socket = IO.io(ApiEndPoints.chatAnonym, <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });
  SharedPreferencesManager prefManager = SharedPreferencesManager();

  // Inisialisasi koneksi dengan token
  Future<void> connect() async {
    final token = await prefManager.getToken();

    if (token == null) return; // Pastikan token tidak null

    socket = IO.io(ApiEndPoints.chatAnonym, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'extraHeaders': {'authorization': 'Bearer $token'},
    });

    socket?.connect();

    // Listener untuk event
    socket?.on('matching', (_) {
      print("Pair found");
    });

    socket?.on('receiveMessage', (message) {
      print("Received: $message");
    });

    socket?.on('waiting', (_) {
      print("Waiting for pair");
    });

    socket?.on('joinRoom', (data) {
      print("Joined room: $data");
    });

    socket?.onDisconnect((_) {
      print("Disconnected from socket.");
    });
  }

  void disconnect() {
    socket?.emit("disconnect");
    socket?.disconnect();
    print("Disconnected from socket.");
  }

  void sendMessage(String message) {
    socket?.emit('sendMessage', {'message': message});
  }
}
