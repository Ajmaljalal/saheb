import 'package:flutter/material.dart';

Widget customButton({userLanguage, appLanguage, context, onClick}) {
  return Padding(
    padding: EdgeInsets.all(8.0),
    child: Container(
      width: MediaQuery.of(context).size.width * 1,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.deepOrange,
        border: Border.all(
          color: Colors.deepOrange,
          width: 3.0,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: FlatButton(
        onPressed: () {
          onClick();
          Navigator.pushReplacementNamed(context, '/login');
        },
        child: Center(
          child: Text(
            userLanguage == 'English' ? 'SignOut' : appLanguage['signOut'],
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
      ),
    ),
  );
}
