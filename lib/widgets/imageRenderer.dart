import 'package:flutter/material.dart';

Widget singleImageRenderer(
  url,
  context,
  imagesWidth,
  boxFitValue,
) {
  return Container(
    width: imagesWidth,
    child: Image.network(
      url,
      fit: boxFitValue,
      semanticLabel: "post's images",
      frameBuilder: (BuildContext context, Widget child, int frame,
          bool wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child;
        }
        return AnimatedOpacity(
          child: child,
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      },
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes
                : null,
          ),
        );
      },
    ),
  );
}
