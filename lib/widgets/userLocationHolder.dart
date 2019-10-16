import 'package:flutter/material.dart';
import '../constant_widgets/constants.dart';

Widget userLocationHolder(location) {
  return Container(
    child: Text(
      location,
      style: kUserLocationProfileStyle,
    ),
  );
}
