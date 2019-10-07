import 'package:flutter/cupertino.dart';

class Store with ChangeNotifier {
  String _language = 'pashto';

  get getLanguage {
    return _language;
  }

  changeLanguage(lang) {
    _language = lang;
    notifyListeners();
  }
}
