import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CheckInStorage {
  static const String _keyCheckInDates = 'checkin_dates';

  // 获取所有打卡日期
  static Future<List<String>> getCheckInDates() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyCheckInDates);
    if (jsonString != null) {
      try {
        final List<dynamic> list = json.decode(jsonString);
        return list.cast<String>();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  // 添加打卡日期（格式：yyyy-MM-dd）
  static Future<void> addCheckInDate(String date) async {
    final list = await getCheckInDates();
    if (!list.contains(date)) {
      list.add(date);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyCheckInDates, json.encode(list));
    }
  }

  // 检查某天是否已打卡
  static Future<bool> isCheckedIn(String date) async {
    final list = await getCheckInDates();
    return list.contains(date);
  }

  // 获取今天的日期字符串（yyyy-MM-dd）
  static String getTodayDateString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}

