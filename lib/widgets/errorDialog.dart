import 'package:flutter/material.dart';

void showErrorDialog(String message, context, String title, String action) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 25.0,
        ),
      ),
      content: Text(
        message,
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            action,
            style: TextStyle(
              color: Colors.cyan,
              fontSize: 20.0,
            ),
          ),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        )
      ],
    ),
  );
}
