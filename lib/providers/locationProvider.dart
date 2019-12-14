import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocationProvider with ChangeNotifier {
  String _userLocality;
  String _userProvince;

  get getUserLocality {
    return _userLocality;
  }

  get getUserProvince {
    return _userProvince;
  }

  Future<void> setLocation() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userProvince')) {
      return;
    }

    if (!prefs.containsKey('userLocality')) {
      return;
    }

    final extractedUserProvinceData = await json
        .decode(prefs.getString('userProvince')) as Map<String, Object>;
    final extractedUserLocalityData = await json
        .decode(prefs.getString('userLocality')) as Map<String, Object>;
    _userProvince = extractedUserProvinceData['province'];
    _userLocality = extractedUserLocalityData['locality'];
    notifyListeners();
  }

  Future<void> changeUserProvince(province) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userProvince = json.encode(
        {
          'province': province,
        },
      );
      await prefs.setString('userProvince', userProvince);
      _userProvince = province;
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> changeUserLocality(locality) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userLocality = json.encode(
        {
          'locality': locality,
        },
      );
      await prefs.setString('userLocality', userLocality);
      _userLocality = locality;
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }
}
