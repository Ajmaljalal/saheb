import 'package:flutter/material.dart';

Widget singleImageRenderer(url) {
  return Container(
    width: 150,
    height: 150,
    padding: EdgeInsets.only(bottom: 8.0, left: 2.0),
    child: ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(5.0),
      ),
      child: Image.network(
        url,
        fit: BoxFit.fill,
      ),
    ),
  );
}
