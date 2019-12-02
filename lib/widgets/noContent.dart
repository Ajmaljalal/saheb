import 'package:flutter/material.dart';

Widget noContent(text, context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.6,
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 25.0,
          color: Colors.cyan,
        ),
      ),
    ),
  );
}
