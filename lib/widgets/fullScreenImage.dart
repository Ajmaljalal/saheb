import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../widgets/imageRenderer.dart';
import '../mixins/post.dart';

class FullScreenImage extends StatelessWidget with PostMixin {
  final List images;
  final BoxFit boxFitValue;
  FullScreenImage({this.images, this.boxFitValue});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              child: renderFullScreenImages(
                  images: images, boxFitValue: boxFitValue, context: context),
            ),
            IconButton(
              icon: Icon(
                Icons.clear,
                size: 40.0,
                color: Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget renderFullScreenImages({
    images,
    boxFitValue,
    context,
  }) {
    final imagesWidth = MediaQuery.of(context).size.width * 1;
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 1,
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return singleImageRenderer(
                images[index], context, imagesWidth, boxFitValue);
          },
          itemCount: images.length,
          pagination: const SwiperPagination(),
          control: const SwiperControl(),
          loop: false,
        ),
      ),
    );
  }
}
