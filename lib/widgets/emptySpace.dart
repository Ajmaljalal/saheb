import 'package:flutter/material.dart';

class EmptySpace extends StatelessWidget {
  final height;
  final width;
  const EmptySpace({
    Key key,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height != null ? height : 0,
      width: width != null ? width : 0,
    );
  }
}
