import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import '../widgets/verticalDivider.dart';
//import '../constant_widgets/constants.dart';

class AdvertMixin {
  Widget advertActionButtons(onClickComment) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkResponse(
            splashColor: Colors.grey[200],
            radius: 25.0,
            child: Icon(
              Icons.message,
              color: Colors.deepPurple,
              size: 20,
            ),
            onTap: () {},
          ),
          InkResponse(
            splashColor: Colors.grey[200],
            radius: 25.0,
            child: Icon(
              Icons.call,
              color: Colors.red,
              size: 22,
            ),
            onTap: () {},
          ),
          InkResponse(
            splashColor: Colors.grey[200],
            radius: 25.0,
            child: Icon(
              Icons.add_comment,
              color: Colors.deepPurple,
              size: 20,
            ),
            onTap: () {
              onClickComment();
            },
          ),
          InkResponse(
            splashColor: Colors.grey[200],
            radius: 25.0,
            child: Icon(
              Icons.delete,
              color: Colors.deepPurple,
              size: 20,
            ),
            onTap: () {
              print('delete clicked');
            },
          ),
        ],
      ),
    );
  }
}
