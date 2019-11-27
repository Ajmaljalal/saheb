import 'package:flutter/material.dart';

Widget singleImageRenderer(url, context, imagesWidth) {
  return Container(
    width: imagesWidth,
    padding: const EdgeInsets.only(left: 1.0),
    child: Image.network(
      url,
      fit: BoxFit.cover,
    ),
  );
}
