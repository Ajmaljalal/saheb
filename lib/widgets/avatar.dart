import 'package:flutter/material.dart';

Widget userAvatar({height, width, photo}) {
  return Container(
    width: width,
    height: height,
    child: CircleAvatar(
      backgroundImage: NetworkImage(
        photo,
      ),
    ),
  );
}
