import 'package:flutter/material.dart';

Widget customButton(
    {userLanguage, appLanguage, context, onClick, forText, width, height}) {
  return Padding(
    padding: EdgeInsets.all(8.0),
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: FlatButton(
        highlightColor: Theme.of(context).accentColor,
        onPressed: () {
          onClick();
        },
        child: Center(
          child: Text(
            userLanguage == 'English'
                ? forText.toUpperCase()
                : appLanguage['$forText'],
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    ),
  );
}
