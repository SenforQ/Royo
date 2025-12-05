import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static const String _keyNickname = 'user_nickname';
  static const String _keySignature = 'user_signature';
  static const String _keyAvatarPath = 'user_avatar_path';

  static Future<String> getNickname() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyNickname) ?? 'Royo';
  }

  static Future<void> setNickname(String nickname) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyNickname, nickname);
  }

  static Future<String> getSignature() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySignature) ?? '';
  }

  static Future<void> setSignature(String signature) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySignature, signature);
  }

  static Future<String?> getAvatarPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAvatarPath);
  }

  static Future<void> setAvatarPath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAvatarPath, path);
  }
}

