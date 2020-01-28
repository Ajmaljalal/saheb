import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget singleImageRenderer(
  url,
  context,
  imagesWidth,
  boxFitValue,
) {
  return AspectRatio(
    aspectRatio: 16 / 9,
    child: Container(
      color: Colors.black,
      width: imagesWidth,
      child: CachedNetworkImage(
        imageUrl: url,
        filterQuality: FilterQuality.medium,
      ),
    ),
  );
}
