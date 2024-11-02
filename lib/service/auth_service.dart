import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:anonymous_chat/api/api_endpoint.dart';

class AuthService {
  static Future<Map<String, dynamic>> registerUser(String username,
      String fullName, String phoneNumber, String password) async {
    const String apiUrl = ApiEndPoints.register;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'full_name': fullName,
          'phone_number': phoneNumber,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        // Handle successful response (201 Created)
        final jsonResponse = jsonDecode(response.body);
        return {'success': true, 'message': jsonResponse['message']};
      } else {
        // Return error message
        final jsonResponse = jsonDecode(response.body);
        return {
          'success': false,
          'status': jsonResponse['status'],
          'errors': jsonResponse['errors'],
        };
      }
    } catch (error) {
      return {'success': false, 'message': error.toString()};
    }
  }

  static Future<Map<String, dynamic>> loginUser(
      String usernameOrPhoneNumber, String password) async {
    const String apiUrl = ApiEndPoints.login;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username_or_phone_number': usernameOrPhoneNumber,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Handle successful response (200 OK)
        final jsonResponse = jsonDecode(response.body);
        return {
          'success': true,
          'message': jsonResponse['message'],
        };
      } else {
        // Return error message
        final jsonResponse = jsonDecode(response.body);
        return {
          'success': false,
          'status': jsonResponse['status'],
          'message': jsonResponse['message'],
          'tags': jsonResponse['tags'],
          'errors': jsonResponse['errors'],
        };
      }
    } catch (error) {
      return {
        'success': false,
        'message': error.toString(),
      };
    }
  }
}
