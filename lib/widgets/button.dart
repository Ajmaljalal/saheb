import 'package:flutter/material.dart';

Widget customButton({
  appLanguage,
  context,
  onClick,
  forText,
  width,
  height,
  fontSize,
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.purple,
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
            fontSize: fontSize,
            color: Colors.white,
            height: 0.9,
          ),
        ),
      ),
    ),
  );
}
