import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

Widget singleImageRenderer(
  url,
  context,
  imagesWidth,
  boxFitValue,
) {
  return Container(
    width: imagesWidth,
    child: CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => Center(
        child: Platform.isIOS
            ? CupertinoActivityIndicator()
            : CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
      fit: boxFitValue,
    ),
  );
}
