import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> saveUserData(
      String userName,
      String fullName,
      String phoneNumber,
      String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(userNameKey, userName);
    await prefs.setString(fullNameKey, fullName);
    await prefs.setString(phoneNumberKey, phoneNumber);
    await prefs.setString(userIdKey, userId);
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
}
