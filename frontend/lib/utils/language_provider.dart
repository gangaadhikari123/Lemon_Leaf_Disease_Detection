import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  String _language = 'en';   // 'en' or 'np'

  String get language => _language;
  bool get isNepali  => _language == 'np';

  // Text helpers — returns the right string based on selected language
  String t(String en, String np) => _language == 'np' ? np : en;

  Future<void> loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _language = prefs.getString('language') ?? 'en';
    notifyListeners();
  }

  Future<void> toggleLanguage() async {
    _language = _language == 'en' ? 'np' : 'en';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', _language);
    notifyListeners();
  }
}