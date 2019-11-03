import 'package:flutter/material.dart';

Widget singleImageRenderer(url, context, imagesWidth) {
  return Container(
    width: imagesWidth,
    padding: const EdgeInsets.only(bottom: 8.0, left: 2.0),
    child: Image.network(
      url,
      fit: BoxFit.fill,
    ),
  );
}
