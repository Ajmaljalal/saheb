import 'package:flutter/material.dart';

Widget customButton({appLanguage, context, onClick, forText, width, height}) {
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
        onPressed: () async {
          await onClick();
        },
        child: Center(
          child: Text(
            appLanguage['$forText'],
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ),
  );
}
