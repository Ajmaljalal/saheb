import 'package:flutter/material.dart';

class CircledButton extends StatelessWidget {
  final icon;
  final fillColor;
  final iconColor;
  final width;
  final height;
  final onPressed;
  final iconSize;
  CircledButton({
    Key key,
    this.icon,
    this.fillColor,
    this.iconColor,
    this.width,
    this.height,
    this.onPressed,
    this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints(
        minWidth: width,
        minHeight: height,
      ),
      onPressed: onPressed,
      child: Icon(
        icon,
        size: iconSize,
        color: iconColor,
      ),
      shape: const CircleBorder(),
      fillColor: fillColor,
      elevation: 0.0,
    );
  }
}
