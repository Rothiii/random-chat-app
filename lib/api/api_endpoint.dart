class ApiEndPoints {
  static const String baseUrl = 'https://k46h62n3-3000.asse.devtunnels.ms';
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  static const String me = '$baseUrl/auth/me';
  static const String chatBotV2 = '$baseUrl/bot/chat/completions';

  static const String botUrl = 'https://k46h62n3-1234.asse.devtunnels.ms';
  static const String chatBot = '$botUrl/v1/chat/completions';

  static const String chatUrl = 'https://k46h62n3-3000.asse.devtunnels.ms';
  static const String chatAnonym = '$chatUrl/socket_anonymous_chat';
}
