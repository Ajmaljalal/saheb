import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();
final FacebookLogin _facebookLogin = FacebookLogin();
final Firestore db = Firestore.instance;

/////////////// TODO: Make sure the get token is taking the expiration date into account //////////////
class AuthProvider with ChangeNotifier {
  String _token;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<FirebaseUser> get currentUser async {
    final FirebaseUser user = await _auth.currentUser();
    return user;
  }

  Future<void> registerUserToDb(id, name, email, photo) async {
    final _userRef = db.collection("users").document(id);
    if (_userRef.documentID.toString().isNotEmpty) {
      await _userRef.setData({
        "id": id,
        "name": name,
        "email": email,
        "photoUrl": photo,
        "location": '',
        "hiddenPosts": []
      });
    } else {
      await _userRef.updateData({
        "id": id,
        "name": name,
        "email": email,
        "photoUrl": photo,
        "location": '',
        "hiddenPosts": []
      });
    }
  }

  Future<String> _authenticate(
      String email, String password, name, actionType) async {
    try {
      FirebaseUser _user;
      if (actionType == 'register') {
        _user = (await _auth.createUserWithEmailAndPassword(
                email: email, password: password))
            .user;

        UserUpdateInfo info = new UserUpdateInfo();
        info.displayName = name;
        info.photoUrl =
            'https://firebasestorage.googleapis.com/v0/b/saheb-mobile.appspot.com/o/users%2Fuser.png?alt=media&token=0f61b161-14a4-49ca-af9e-cef6ba8a80ca';
        await _user.updateProfile(info);

        await registerUserToDb(_user.uid, name, email, _user.photoUrl);
      } else {
        _user = (await _auth.signInWithEmailAndPassword(
                email: email, password: password))
            .user;
      }

      // save user token and save user info to local
      _token = (await _user.getIdToken()).token;
      _userId = _user.uid;

      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
        },
      );

      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
    return _userId;
  }

  Future register(String email, String password, String name) async {
    return _authenticate(email, password, name, 'register');
  }

  Future login(String email, String password) async {
    return _authenticate(email, password, '', 'login');
  }

  Future<String> googleSignIn(actionType) async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser _user =
          (await _auth.signInWithCredential(credential)).user;
      _token = (await _user.getIdToken()).token;
      _userId = _user.uid;

      if (actionType == 'register') {
        registerUserToDb(
            _user.uid, _user.displayName, _user.email, _user.photoUrl);
      }

      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
        },
      );
      prefs.setString('userData', userData);
      return _user.uid;
    } catch (error) {
      throw error;
    }
  }

  Future<String> facebookSignIn(actionType) async {
    try {
      final FacebookLoginResult _result =
          await _facebookLogin.logIn(['email', 'public_profile']);
//      switch (_result.status) {
//        case FacebookLoginStatus.loggedIn:
//          _status = 'success';
//          break;
//        case FacebookLoginStatus.cancelledByUser:
//          _status = 'user cancelled loging in';
//          break;
//        case FacebookLoginStatus.error:
//          _status = 'Error happened';
//          break;
//      }
      FacebookAccessToken _facebookToken = _result.accessToken;
      AuthCredential _credential =
          FacebookAuthProvider.getCredential(accessToken: _facebookToken.token);

      final FirebaseUser _user =
          (await _auth.signInWithCredential(_credential)).user;
      _token = (await _user.getIdToken()).token;
      _userId = _user.uid;

      if (actionType == 'register') {
        registerUserToDb(
            _user.uid, _user.displayName, _user.email, _user.photoUrl);
      }

      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
        },
      );
      prefs.setString('userData', userData);

      return _user.uid;
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];

    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }
}
