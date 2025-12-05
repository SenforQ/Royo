import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BlockStorage {
  static const String _keyBlockedList = 'blocked_users_list';
  static const String _keyMutedList = 'muted_users_list';
  static const String _keyReportedList = 'reported_users_list';

  // 获取拉黑列表
  static Future<List<String>> getBlockedList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyBlockedList);
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

  // 添加拉黑
  static Future<void> addBlocked(String nickname) async {
    final list = await getBlockedList();
    if (!list.contains(nickname)) {
      list.add(nickname);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyBlockedList, json.encode(list));
    }
  }

  // 移除拉黑
  static Future<void> removeBlocked(String nickname) async {
    final list = await getBlockedList();
    list.remove(nickname);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyBlockedList, json.encode(list));
  }

  // 获取屏蔽列表
  static Future<List<String>> getMutedList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyMutedList);
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

  // 添加屏蔽
  static Future<void> addMuted(String nickname) async {
    final list = await getMutedList();
    if (!list.contains(nickname)) {
      list.add(nickname);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyMutedList, json.encode(list));
    }
  }

  // 移除屏蔽
  static Future<void> removeMuted(String nickname) async {
    final list = await getMutedList();
    list.remove(nickname);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyMutedList, json.encode(list));
  }

  // 获取举报列表
  static Future<List<String>> getReportedList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyReportedList);
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

  // 添加举报
  static Future<void> addReported(String nickname) async {
    final list = await getReportedList();
    if (!list.contains(nickname)) {
      list.add(nickname);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyReportedList, json.encode(list));
    }
  }

  // 移除举报
  static Future<void> removeReported(String nickname) async {
    final list = await getReportedList();
    list.remove(nickname);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyReportedList, json.encode(list));
  }

  // 检查是否被拉黑、屏蔽或举报
  static Future<bool> isBlockedOrMuted(String nickname) async {
    final blockedList = await getBlockedList();
    final mutedList = await getMutedList();
    final reportedList = await getReportedList();
    return blockedList.contains(nickname) || 
           mutedList.contains(nickname) ||
           reportedList.contains(nickname);
  }
}

