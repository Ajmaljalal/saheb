import 'package:flutter/material.dart';

Widget userNameHolder({name, fontSize}) {
  return Container(
    child: Text(
      name,
      style: TextStyle(
        fontSize: fontSize,
      ),
    ),
  );
}
