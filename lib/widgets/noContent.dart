import 'package:flutter/material.dart';

Widget noContent(appLanguage, context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.6,
    child: Center(
      child: Text(
        appLanguage['noContent'],
        style: TextStyle(
          fontSize: 30.0,
          color: Colors.cyan,
        ),
      ),
    ),
  );
}
