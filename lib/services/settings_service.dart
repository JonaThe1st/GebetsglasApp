import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Lokale Einstellungen (SharedPreferences).
class SettingsService {
  SettingsService._();
  static final SettingsService instance = SettingsService._();

  static const _kEnabled = 'notification_enabled';
  static const _kHour = 'notification_hour';
  static const _kMinute = 'notification_minute';
  static const _kCategoryIds = 'notification_category_ids';

  Future<bool> get enabled async =>
      (await SharedPreferences.getInstance()).getBool(_kEnabled) ?? false;

  Future<int> get hour async =>
      (await SharedPreferences.getInstance()).getInt(_kHour) ?? 7;

  Future<int> get minute async =>
      (await SharedPreferences.getInstance()).getInt(_kMinute) ?? 0;

  Future<List<int>> get categoryIds async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kCategoryIds);
    if (raw == null) return [];
    return (jsonDecode(raw) as List).cast<int>();
  }

  Future<void> setEnabled(bool value) async {
    (await SharedPreferences.getInstance()).setBool(_kEnabled, value);
  }

  Future<void> setTime(int hour, int minute) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_kHour, hour);
    prefs.setInt(_kMinute, minute);
  }

  Future<void> setCategoryIds(List<int> ids) async {
    (await SharedPreferences.getInstance())
        .setString(_kCategoryIds, jsonEncode(ids));
  }
}
