import 'package:flutter/material.dart';
import 'ImageSliderWidgets/ImageSliderWidget.dart';

class ImageSlider extends StatelessWidget {
  final List<dynamic> imageUrls;
  ImageSlider({
    this.imageUrls,
  });
  @override
  Widget build(BuildContext context) {
    return ImageSliderWidget(
      imageUrls: imageUrls,
      imageBorderRadius: BorderRadius.circular(0.0),
    );
  }
}
