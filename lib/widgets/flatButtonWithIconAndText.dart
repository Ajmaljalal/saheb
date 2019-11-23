import 'package:flutter/material.dart';

Widget flatButtonWithIconAndText({
  String text,
  String subText,
  Color color,
  IconData icon,
  onPressed,
}) {
  return FlatButton(
    onPressed: onPressed,
    child: Row(
      children: <Widget>[
        Icon(icon, color: color),
        SizedBox(
          width: 15.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              subText,
              style: TextStyle(fontSize: 13.0, color: Colors.grey),
            ),
          ],
        ),
      ],
    ),
  );
}
