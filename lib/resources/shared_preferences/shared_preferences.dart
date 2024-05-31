import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  // Keys for the preferences
  static const String _keyUsername = 'username';
  static const String _keyUserId = 'userId';

  // Singleton instance
  static final SharedPreferencesHelper _instance = SharedPreferencesHelper._internal();

  factory SharedPreferencesHelper() {
    return _instance;
  }

  SharedPreferencesHelper._internal();

  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  // Save username
  Future<void> setUsername(String username) async {
    final prefs = await _getPrefs();
    await prefs.setString(_keyUsername, username);
  }

  // Get username
  Future<String?> getUsername() async {
    final prefs = await _getPrefs();
    return prefs.getString(_keyUsername);
  }

  // Save user ID
  Future<void> setUserId(String userId) async {
    final prefs = await _getPrefs();
    await prefs.setString(_keyUserId, userId);
  }

  // Get user ID
  Future<String?> getUserId() async {
    final prefs = await _getPrefs();
    return prefs.getString(_keyUserId);
  }

  // Remove all saved preferences
  Future<void> clearAll() async {
    final prefs = await _getPrefs();
    await prefs.clear();
  }

  // Add more fields as needed
  // Save email
  Future<void> setEmail(String email) async {
    final prefs = await _getPrefs();
    await prefs.setString('email', email);
  }

  // Get email
  Future<String?> getEmail() async {
    final prefs = await _getPrefs();
    return prefs.getString('email');
  }

  // Save age
  Future<void> setAge(int age) async {
    final prefs = await _getPrefs();
    await prefs.setInt('age', age);
  }

  // Get age
  Future<int?> getAge() async {
    final prefs = await _getPrefs();
    return prefs.getInt('age');
  }
}
