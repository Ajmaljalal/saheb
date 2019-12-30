import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void showErrorDialog(
  String message,
  context,
  String title,
  String action,
) {
  Alert(
    context: context,
    title: title,
    type: AlertType.error,
    style: const AlertStyle(
      titleStyle: const TextStyle(
        fontSize: 20.0,
        color: Colors.red,
      ),
      isCloseButton: false,
    ),
    content: Text(
      message,
      style: const TextStyle(
        fontSize: 15.0,
      ),
    ),
    buttons: [
      DialogButton(
        color: Colors.purple,
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          action,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ),
    ],
  ).show();
  ;
}
