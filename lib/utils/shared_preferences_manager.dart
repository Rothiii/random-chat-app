import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  final String usernameOrPhoneNumberKey = '';
  final String passwordKey = '';
  final String tokenKey = '';
  final String isLoginInKey = '';
  
  // Save
  Future<void> saveUserCredentials(
      String usernameOrPhoneNumber, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(usernameOrPhoneNumberKey, usernameOrPhoneNumber);
    await prefs.setString(passwordKey, password);
  }

  Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  Future<void> saveIsLoggedIn(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isLoginInKey, isLoggedIn);
  }

  // Remove
  Future<void> deleteUserCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(usernameOrPhoneNumberKey);
    await prefs.remove(passwordKey);
  }

  Future<void> deleteToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  Future<void> deleteIsLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(isLoginInKey);
  }

  // Read
  Future<Map<String, String>> getUserCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? usernameOrPhoneNumber = prefs.getString(usernameOrPhoneNumberKey);
    final String? password = prefs.getString(passwordKey);

    return {
      'usernameOrPhoneNumber': usernameOrPhoneNumber ?? '',
      'password': password ?? '',
    };
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey) ?? '';
  }

  Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLoginInKey) ?? false;
  }
} 