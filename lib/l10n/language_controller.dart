import 'package:flutter/material.dart';

import '../services/settings_service.dart';

/// Steuert die App-Sprache (null = Systemeinstellung folgen).
class LanguageController {
  LanguageController._();

  static final ValueNotifier<Locale?> locale = ValueNotifier<Locale?>(null);

  static Future<void> load() async {
    locale.value = await SettingsService.instance.languageLocale;
  }

  static Future<void> setLanguage(String code) async {
    await SettingsService.instance.setLanguage(code);
    locale.value = await SettingsService.instance.languageLocale;
  }
}
