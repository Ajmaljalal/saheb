import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:provider/provider.dart';
//import '../providers/languageProvider.dart';
import '../languages/index.dart';

class AdvertMixin {
  Widget advertActionButtons({
    onClickComment,
    advertId,
    userId,
    advert,
    advertTitle,
    flag,
    updateLikes,
    onDeleteAdvert,
    onCallPhoneNumber,
    context,
  }) {
    final appLanguage = getLanguages(context);
    final screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width * 0.85,
      padding: const EdgeInsets.symmetric(
        horizontal: 2.0,
        vertical: 5.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
//            width: screenSize.width * 0.20,
            height: 30,
            child: OutlineButton.icon(
              splashColor: Colors.grey[200],
              icon: Icon(
                FontAwesomeIcons.comments,
                color: Colors.grey,
                size: 15,
              ),
              label: Text(
                appLanguage['text'],
                style: TextStyle(fontSize: 10, color: Colors.grey[700]),
              ),
              borderSide: BorderSide.none,
              onPressed: () {
                print('I am pressed');
              },
            ),
          ),
          Container(
//            width: screenSize.width * 0.25,
            height: 30,
            child: OutlineButton.icon(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
              splashColor: Colors.grey[200],
              icon: const Icon(
                FontAwesomeIcons.phone,
                color: Colors.grey,
                size: 15,
              ),
              label: Text(
                appLanguage['call'],
                style: TextStyle(fontSize: 10, color: Colors.grey[700]),
              ),
              borderSide: BorderSide.none,
              onPressed: () {
                onCallPhoneNumber(advert['phone']);
              },
            ),
          ),
          Container(
//            width: screenSize.width * 0.28,
            height: 30,
            child: OutlineButton.icon(
              splashColor: Colors.grey[200],
              icon: Icon(
                FontAwesomeIcons.comment,
                color: Colors.grey,
                size: 15,
              ),
              label: Text(
                appLanguage['comment'],
                style: TextStyle(fontSize: 10, color: Colors.grey[700]),
              ),
              borderSide: BorderSide.none,
              onPressed: () {
                if (flag == 'details') {
                  onClickComment();
                } else {
                  onClickComment(advertId, advertTitle);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
