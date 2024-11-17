import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  // Save user data
  Future<void> saveUserData({
    required String name,
    required String email,
    required String profileUrl,
    required String userId,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('profileUrl', profileUrl);
    await prefs.setString('userId', userId);
  }

  // Retrieve user data
  Future<Map<String, String?>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? name = prefs.getString('name');
    String? email = prefs.getString('email');
    String? profileUrl = prefs.getString('profileUrl');
    String? userId = prefs.getString('userId');

    return {
      'name': name,
      'email': email,
      'profileUrl': profileUrl,
      'userId': userId,
    };
  }

  // Clear user data
  Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('profileUrl');
    await prefs.remove('userId');
  }
}
