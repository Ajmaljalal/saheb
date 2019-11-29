import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';

class LocationProvider with ChangeNotifier {
  String _location;
  String _province;

  get getLocation {
    return _location;
  }

  get getUserProvince {
    return _province;
  }

  Future<void> setLocation() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userLocation')) {
      return;
    }
    final extractedUserData =
        json.decode(prefs.getString('userLocation')) as Map<String, Object>;
    _location = extractedUserData['location'];
    notifyListeners();
  }

  Future<void> changeLocation(location) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userLocation = json.encode(
        {
          'location': location,
        },
      );
      prefs.setString('userLocation', userLocation);
      _location = location;
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }

  Future<String> getProvince() async {
    var province;
    if (_province == null) {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      List<Placemark> placemark = await Geolocator()
          .placemarkFromCoordinates(position.latitude, position.longitude);
      province = placemark[0].locality.toString().toLowerCase();
      if (province == 'sacramento') {
        province = 'kabul';
      }
      _province = province;
      notifyListeners();
      return province;
    } else
      return _province;
  }
}
