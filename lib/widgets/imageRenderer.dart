import 'package:flutter/material.dart';

Widget singleImageRenderer(url, context, imagesWidth) {
  return Container(
    width: imagesWidth,
    child: Image.network(
      url,
      fit: BoxFit.cover,
    ),
  );
}
