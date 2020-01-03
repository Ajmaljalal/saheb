import 'package:flutter/material.dart';

Widget circularProgressIndicator() {
  return Center(
    child: Container(
      width: 30.0,
      height: 30.0,
      child: const CircularProgressIndicator(
        backgroundColor: Colors.white,
      ),
    ),
  );
}

Widget linearProgressIndicator() {
  return const LinearProgressIndicator(
    backgroundColor: Colors.white,
  );
}
