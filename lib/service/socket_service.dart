import 'package:anonymous_chat/api/api_endpoint.dart';
import 'package:anonymous_chat/utils/shared_preferences_manager.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? socket;
  SharedPreferencesManager prefManager = SharedPreferencesManager();

  Future<void> connect(Function(String, dynamic) updateStateCallback) async {
    final token = await prefManager.getToken();

    socket = IO.io(ApiEndPoints.chatAnonym, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'extraHeaders': {'authorization': 'Bearer $token'},
    });

    socket?.on('connect', (_) {
      print('Socket connected in service');
    });

    socket?.on('disconnect', (_) {
      print('Socket disconnected');
    });

    socket?.on('matching', (_) {
      print("Matched with partner");
      updateStateCallback('matching', null);
    });

    socket?.on('partnerDisconnect', (_) {
      print("Partner disconnected");
      updateStateCallback('partnerDisconnect', null);
    });

    socket?.on('receiveMessage', (data) {
      updateStateCallback('receiveMessage', data);
    });

    socket?.on('joinRoom', (data) {
      socket?.emit('joinRoomAck', data['room_id']);
    });

    socket?.on('sendMessage', (data) {
      updateStateCallback('sendMessage', data);
    });
  }
}
