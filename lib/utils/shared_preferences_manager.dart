import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:anonymous_chat/models/user-login.dart';

class SharedPreferencesManager {
  final String tokenKey = 'token';
  final String isLoginInKey = 'isLoggedIn';
  final String userNameKey = 'userName';
  final String fullNameKey = 'fullName';
  final String phoneNumberKey = 'phoneNumber';
  final String userIdKey = 'userId';

  // Save

  Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  Future<void> saveIsLoggedIn(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isLoginInKey, isLoggedIn);
  }

  Future<void> saveUserData(String userName, String fullName,
      String phoneNumber, String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(userNameKey, userName);
    await prefs.setString(fullNameKey, fullName);
    await prefs.setString(phoneNumberKey, phoneNumber);
    await prefs.setString(userIdKey, userId);
  }

  Future<void> saveUser(UserLogin user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));
  }
  // Remove

  Future<void> deleteToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  Future<void> deleteIsLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(isLoginInKey);
  }

  Future<void> deleteUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(userNameKey);
    await prefs.remove(fullNameKey);
    await prefs.remove(phoneNumberKey);
    await prefs.remove(userIdKey);
  }

  // Read
  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey) ?? '';
  }

  Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLoginInKey) ?? false;
  }

  Future<List<String>> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return [
      prefs.getString(userNameKey) ?? '',
      prefs.getString(fullNameKey) ?? '',
      prefs.getString(phoneNumberKey) ?? '',
      prefs.getString(userIdKey) ?? '',
    ];
  }

  Future<UserLogin?> getUser() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? userData = prefs.getString('user');
  if (userData != null) {
    return UserLogin.fromJson(jsonDecode(userData));
  }
  return null;
}
} 
