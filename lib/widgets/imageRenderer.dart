import 'package:flutter/material.dart';

Widget singleImageRenderer(url, context, imagesWidth, boxFitValue) {
  return Container(
    width: imagesWidth,
    child: Image.network(
      url,
      fit: boxFitValue,
    ),
  );
}
