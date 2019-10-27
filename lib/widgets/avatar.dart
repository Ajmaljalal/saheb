import 'package:flutter/material.dart';

Widget imageRenderer({height, width, photo}) {
  return Container(
    width: width,
    height: height,
    padding: EdgeInsets.all(10),
    child: CircleAvatar(
      backgroundImage: NetworkImage(
        photo,
      ),
    ),
  );
}
