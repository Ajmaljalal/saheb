import 'package:flutter/material.dart';

Widget userNameHolder({name, fontSize}) {
  return Container(
    height: 35.0,
    child: Text(
      name,
      style: TextStyle(
        fontSize: fontSize,
      ),
    ),
  );
}
