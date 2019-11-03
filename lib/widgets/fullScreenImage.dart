import 'package:flutter/material.dart';
import '../mixins/post.dart';

class FullScreenImage extends StatelessWidget with PostMixin {
  final List images;
  FullScreenImage({this.images});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              child: renderFullScreenImages(images: images, context: context),
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
}
