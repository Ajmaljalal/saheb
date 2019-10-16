import 'package:flutter/foundation.dart';
import 'dummy_data.dart';

class Adverts with ChangeNotifier {
  Map _adverts = posts;

  get getAdverts {
    return _adverts;
  }
}
