import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore db = Firestore.instance;

/////////////// TODO: Make sure the get token is taking the expiration date into account //////////////
class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
//    if (_expiryDate != null &&
//        _expiryDate.isAfter(DateTime.now()) &&
//        _token != null) {
    return _token;
//    }
//    return null;
  }

  String get userId {
    return _userId;
  }

  registerUserToDb(id, name, email) async {
    await db.collection("users").document(id).setData({
      "id": id,
      "name": name,
      "email": email,
      "photoUrl": '',
      "location": '',
      "hiddenPosts": []
    });
  }

  Future<String> _authenticate(
      String email, String password, name, actionType) async {
    try {
      FirebaseUser _user;
      if (actionType == 'register') {
        _user = (await _auth.createUserWithEmailAndPassword(
                email: email, password: password))
            .user;
        registerUserToDb(_user.uid, name, email);
      } else {
        _user = (await _auth.signInWithEmailAndPassword(
                email: email, password: password))
            .user;
      }

      // save user token and save user info to local
      _token = (await _user.getIdToken()).token;
      _userId = _user.uid;
//      _expiryDate = DateTime.now().add(
//        Duration(
//          seconds:
//              int.parse((await _user.getIdToken()).expirationTime),
//        ),
//      );
//      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate,
        },
      );

      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
    return _userId;
  }

  Future<String> register(String email, String password, String name) async {
    return _authenticate(email, password, name, 'register');
  }

  Future<String> login(String email, String password) async {
    return _authenticate(email, password, '', 'login');
  }

//  void _autoLogout() {
//    if (_authTimer != null) {
//      _authTimer.cancel();
//    }
//    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
//    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
//  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
//    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }
}
