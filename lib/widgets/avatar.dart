import 'package:com.pywast.pywast/widgets/emptyBox.dart';
import 'package:flutter/material.dart';

Widget userAvatar({
  height,
  width,
  photo,
}) {
  return Container(
    width: width,
    height: height,
    child: photo != null
        ? CircleAvatar(
            backgroundImage: NetworkImage(
              photo,
            ),
          )
        : emptyBox(),
  );
}
