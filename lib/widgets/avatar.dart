import 'package:flutter/material.dart';

Widget imageRenderer({height, width}) {
  return Container(
    width: width,
    height: height,
    padding: EdgeInsets.all(10),
    child: CircleAvatar(
        backgroundImage: NetworkImage(
      'https://cdn.pixabay.com/photo/2014/03/24/17/19/teacher-295387_1280.png',
    )),
  );
}
