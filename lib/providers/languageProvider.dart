import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LanguageProvider with ChangeNotifier {
  String _language;

  get getLanguage {
    return _language;
  }

  Future<void> setLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('uiLanguage')) {
      return;
    }
    final extractedUserData =
        json.decode(prefs.getString('uiLanguage')) as Map<String, Object>;
    _language = extractedUserData['language'];
    notifyListeners();
  }

  Future<void> changeLanguage(lang) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final uiLanguage = json.encode(
        {
          'language': lang,
        },
      );
      prefs.setString('uiLanguage', uiLanguage);
      _language = lang;
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }
}
