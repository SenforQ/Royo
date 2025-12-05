import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WorkoutStorage {
  static const String _keyTotalHours = 'total_workout_hours';
  static const String _keyDailyHours = 'daily_workout_hours';

  static Future<double> getTotalHours() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyTotalHours) ?? 0.0;
  }

  static Future<void> addHours(double hours) async {
    final prefs = await SharedPreferences.getInstance();
    final currentHours = await getTotalHours();
    await prefs.setDouble(_keyTotalHours, currentHours + hours);
    
    // 记录当天的锻炼时长
    await addTodayHours(hours);
  }

  static Future<void> setTotalHours(double hours) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyTotalHours, hours);
  }

  // 获取今天的日期字符串（yyyy-MM-dd）
  static String getTodayDateString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  // 添加今天的锻炼时长
  static Future<void> addTodayHours(double hours) async {
    final today = getTodayDateString();
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyDailyHours);
    Map<String, double> dailyHours = {};
    
    if (jsonString != null) {
      try {
        final decoded = json.decode(jsonString);
        dailyHours = Map<String, double>.from(decoded.map((key, value) => 
          MapEntry(key, (value as num).toDouble())));
      } catch (e) {
        dailyHours = {};
      }
    }
    
    dailyHours[today] = (dailyHours[today] ?? 0.0) + hours;
    await prefs.setString(_keyDailyHours, json.encode(dailyHours));
  }

  // 获取今天的总锻炼时长（分钟）
  static Future<double> getTodayTotalMinutes() async {
    final today = getTodayDateString();
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyDailyHours);
    
    if (jsonString != null) {
      try {
        final decoded = json.decode(jsonString);
        final dailyHours = Map<String, double>.from(decoded.map((key, value) => 
          MapEntry(key, (value as num).toDouble())));
        final todayHours = dailyHours[today] ?? 0.0;
        return todayHours * 60; // 转换为分钟
      } catch (e) {
        return 0.0;
      }
    }
    return 0.0;
  }
}

