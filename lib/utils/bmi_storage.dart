import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BmiHistoryEntry {
  final double value;
  final DateTime dateTime;

  BmiHistoryEntry({
    required this.value,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory BmiHistoryEntry.fromJson(Map<String, dynamic> json) {
    return BmiHistoryEntry(
      value: json['value'] as double,
      dateTime: DateTime.parse(json['dateTime'] as String),
    );
  }
}

class BmiStorage {
  static const String _keyCurrentBmi = 'current_bmi';
  static const String _keyBmiHistory = 'bmi_history';

  static Future<double?> getCurrentBmi() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getDouble(_keyCurrentBmi);
    return value;
  }

  static Future<void> setCurrentBmi(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyCurrentBmi, value);
    await _addToHistory(value);
  }

  static Future<void> _addToHistory(double value) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_keyBmiHistory);
    List<BmiHistoryEntry> history = [];
    
    if (historyJson != null) {
      final List<dynamic> decoded = jsonDecode(historyJson);
      history = decoded.map((e) => BmiHistoryEntry.fromJson(e as Map<String, dynamic>)).toList();
    }
    
    history.insert(0, BmiHistoryEntry(value: value, dateTime: DateTime.now()));
    
    final encoded = jsonEncode(history.map((e) => e.toJson()).toList());
    await prefs.setString(_keyBmiHistory, encoded);
  }

  static Future<List<BmiHistoryEntry>> getBmiHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_keyBmiHistory);
    
    if (historyJson == null) {
      return [];
    }
    
    final List<dynamic> decoded = jsonDecode(historyJson);
    return decoded.map((e) => BmiHistoryEntry.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyBmiHistory);
  }
}

