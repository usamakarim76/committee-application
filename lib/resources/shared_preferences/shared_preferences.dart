import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  // Keys for the preferences
  static const String _keyUsername = 'username';
  static const String _keyUserId = 'userId';

  static Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  // Save username
  static Future<void> setUsername(String username) async {
    final prefs = await _getPrefs();
    await prefs.setString(_keyUsername, username);
  }

  // Get username
  static Future<String?> getUsername() async {
    final prefs = await _getPrefs();
    return prefs.getString(_keyUsername);
  }

  // Save user ID
  static Future<void> setUserId(String userId) async {
    final prefs = await _getPrefs();
    await prefs.setString(_keyUserId, userId);
  }

  // Get user ID
  static Future<String?> getUserId() async {
    final prefs = await _getPrefs();
    return prefs.getString(_keyUserId);
  }

  // Remove all saved preferences
  static Future<void> clearAll() async {
    final prefs = await _getPrefs();
    await prefs.clear();
  }

  // Add more fields as needed
  // Save email
  static Future<void> setEmail(String email) async {
    final prefs = await _getPrefs();
    await prefs.setString('email', email);
  }

  // Get email
  static Future<String?> getEmail() async {
    final prefs = await _getPrefs();
    return prefs.getString('email');
  }

  // // Save age
  // static Future<void> setAge(int age) async {
  //   final prefs = await _getPrefs();
  //   await prefs.setInt('age', age);
  // }
  //
  // // Get age
  // static Future<int?> getAge() async {
  //   final prefs = await _getPrefs();
  //   return prefs.getInt('age');
  // }
}
