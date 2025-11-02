import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const _kId = 'id';
  static const _kName = 'name';
  static const _kEmail = 'email';
  
  static Null get user => null;

  static Future<void> saveUserData({
    required String id,
    required String name,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kId, id);
    await prefs.setString(_kName, name);
    await prefs.setString(_kEmail, email);
  }

  static Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getString(_kId),
      'name': prefs.getString(_kName),
      'email': prefs.getString(_kEmail),
    };
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kId) != null;
  }

  static Future<void> clearUserData() async {}
}
