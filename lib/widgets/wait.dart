import 'package:flutter/material.dart';

Widget wait(text, context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.6,
    child: Center(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 25.0,
          color: Colors.cyan,
        ),
      ),
    ),
  );
}
