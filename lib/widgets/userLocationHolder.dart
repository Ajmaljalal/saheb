import 'package:flutter/material.dart';
import '../constants/constants.dart';

Widget userLocationHolder(location) {
  return Container(
    child: Text(
      location,
      style: kUserLocationProfileStyle,
    ),
  );
}
