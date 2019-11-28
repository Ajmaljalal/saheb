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
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    var province = placemark[0].locality.toString().toLowerCase();
    if (province == 'sacramento') {
      province = 'kabul';
    }
    _province = province;
    notifyListeners();
    return province;
  }
}
