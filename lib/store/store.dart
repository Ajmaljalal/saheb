import 'package:flutter/cupertino.dart';
import 'dummy_data.dart';

class Store with ChangeNotifier {
  String _language = 'pashto';
  Map _posts = posts;

  get getLanguage {
    return _language;
  }

  get getPosts {
    return _posts;
  }

  changeLanguage(lang) {
    _language = lang;
    notifyListeners();
  }
}
