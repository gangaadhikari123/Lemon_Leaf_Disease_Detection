import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  String _language = 'en';

  String get language => _language;
  bool get isNepali  => _language == 'np';

  String t(String en, String np) => _language == 'np' ? np : en;

  Future<void> loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _language = prefs.getString('language') ?? 'en';
      notifyListeners();
    } catch (_) {
      // SharedPreferences not available in test — use default 'en'
      _language = 'en';
    }
  }

  Future<void> toggleLanguage() async {
    _language = _language == 'en' ? 'np' : 'en';
    notifyListeners();   // ← notify immediately
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', _language);
    } catch (_) {
      // SharedPreferences not available in test — ignore
    }
  }

  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }
}