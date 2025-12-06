import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WorkoutStorage {
  static const String _keyTotalHours = 'total_workout_hours';
  static const String _keyDailyHours = 'daily_workout_hours';
  static const String _keyDailyGoal = 'daily_workout_goal_minutes';

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

  // 获取每日目标（分钟）
  static Future<double> getDailyGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyDailyGoal) ?? 30.0; // 默认30分钟
  }

  // 设置每日目标（分钟）
  static Future<void> setDailyGoal(double minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyDailyGoal, minutes);
  }

  // 获取本周的锻炼统计
  static Future<Map<String, dynamic>> getWeeklyStats() async {
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

    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));
    double totalMinutes = 0.0;
    int workoutDays = 0;

    for (int i = 0; i < 7; i++) {
      final date = startOfWeek.add(Duration(days: i));
      final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final hours = dailyHours[dateString] ?? 0.0;
      final minutes = hours * 60;
      if (minutes > 0) {
        totalMinutes += minutes;
        workoutDays++;
      }
    }

    return {
      'totalMinutes': totalMinutes,
      'workoutDays': workoutDays,
      'averageMinutes': workoutDays > 0 ? totalMinutes / workoutDays : 0.0,
    };
  }

  // 获取本月的锻炼统计
  static Future<Map<String, dynamic>> getMonthlyStats() async {
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

    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    double totalMinutes = 0.0;
    int workoutDays = 0;

    for (int i = 0; i <= endOfMonth.difference(startOfMonth).inDays; i++) {
      final date = startOfMonth.add(Duration(days: i));
      final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final hours = dailyHours[dateString] ?? 0.0;
      final minutes = hours * 60;
      if (minutes > 0) {
        totalMinutes += minutes;
        workoutDays++;
      }
    }

    return {
      'totalMinutes': totalMinutes,
      'workoutDays': workoutDays,
      'averageMinutes': workoutDays > 0 ? totalMinutes / workoutDays : 0.0,
    };
  }

  // 获取最近7天的锻炼记录
  static Future<List<Map<String, dynamic>>> getRecentWorkouts(int days) async {
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

    final now = DateTime.now();
    List<Map<String, dynamic>> workouts = [];

    for (int i = days - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final hours = dailyHours[dateString] ?? 0.0;
      final minutes = hours * 60;
      
      workouts.add({
        'date': dateString,
        'minutes': minutes,
        'dateTime': date,
      });
    }

    return workouts;
  }
}

