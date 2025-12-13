import 'package:shared_preferences/shared_preferences.dart';

class CoinService {
  static const String _keyCurrentCoins = 'current_coins';
  static const int _defaultCoins = 0;

  static Future<void> initializeNewUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_keyCurrentCoins)) {
      await prefs.setInt(_keyCurrentCoins, _defaultCoins);
    }
  }

  static Future<int> getCurrentCoins() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyCurrentCoins) ?? _defaultCoins;
  }

  static Future<bool> addCoins(int coins) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final current = await getCurrentCoins();
      await prefs.setInt(_keyCurrentCoins, current + coins);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deductCoins(int coins) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final current = await getCurrentCoins();
      if (current >= coins) {
        await prefs.setInt(_keyCurrentCoins, current - coins);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}

