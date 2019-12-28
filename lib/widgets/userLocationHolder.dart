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

Widget userLocationEditor({onTap, appLanguage, context}) {
  return Container(
    height: 25.0,
    width: 25.0,
    child: InkWell(
      onTap: () => onTap(appLanguage),
      child: Icon(
        Icons.edit,
        size: 15.0,
        color: Colors.green,
      ),
    ),
  );
}
