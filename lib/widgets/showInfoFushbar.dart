import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';

void showInfoFlushbar({
  BuildContext context,
  duration,
  String message,
  icon,
  bool progressBar,
  bool positionTop,
}) {
  Flushbar(
    flushbarPosition:
        positionTop ? FlushbarPosition.TOP : FlushbarPosition.BOTTOM,
    flushbarStyle: FlushbarStyle.FLOATING,
    reverseAnimationCurve: Curves.decelerate,
    forwardAnimationCurve: Curves.elasticOut,
    backgroundColor: Colors.white,
    boxShadows: [
      BoxShadow(color: Colors.black, offset: Offset(0.0, 2.0), blurRadius: 3.0)
    ],
    isDismissible: false,
    duration: Duration(seconds: duration),
    icon: Icon(
      icon,
      color: Colors.green,
    ),
    showProgressIndicator: progressBar,
    progressIndicatorBackgroundColor: Colors.blueGrey,
    messageText: Center(
      child: Text(
        message.toString(),
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.black,
        ),
      ),
    ),
  ).show(context);
}
