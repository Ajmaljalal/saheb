import 'package:flutter/material.dart';

Widget userNameHolder({name, fontSize}) {
  return Container(
    height: 30.0,
    child: Text(
      name,
      style: TextStyle(
        fontSize: fontSize,
      ),
    ),
  );
}
