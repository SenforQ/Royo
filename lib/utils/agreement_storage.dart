import 'package:shared_preferences/shared_preferences.dart';

class AgreementStorage {
  static const String _keyAgreed = 'user_agreed_to_terms';

  // 检查用户是否已同意协议
  static Future<bool> hasAgreed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyAgreed) ?? false;
  }

  // 设置用户已同意协议
  static Future<void> setAgreed(bool agreed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAgreed, agreed);
  }
}

