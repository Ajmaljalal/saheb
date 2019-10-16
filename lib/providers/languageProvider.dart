import 'package:flutter/foundation.dart';

class LanguageProvider with ChangeNotifier {
  String _language = 'pashto';

  get getLanguage {
    return _language;
  }

  changeLanguage(lang) {
    _language = lang;
    notifyListeners();
  }
}
