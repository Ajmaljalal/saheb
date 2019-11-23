import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saheb/providers/postsProvider.dart';
import '../../providers/languageProvider.dart';
import '../../constants/constants.dart';
import '../../providers/authProvider.dart';
import 'advertDetails.dart';
import '../../mixins/post.dart';
import '../../mixins/advert.dart';
import '../../languages/index.dart';

class Advert extends StatefulWidget {
  final DocumentSnapshot advert;
  Advert({Key key, this.advert}) : super(key: key);

  @override
  _AdvertState createState() => _AdvertState();
}

class _AdvertState extends State<Advert> with PostMixin, AdvertMixin {
  bool revealMoreTextFlag = false;

  _revealMoreText() {
    setState(() {
      revealMoreTextFlag = !revealMoreTextFlag;
    });
  }

  goToDetailsScreen(advertId, advertTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdvertDetails(
          advertTitle: advertTitle,
          advertId: advertId,
        ),
      ),
    );
  }

//  updateLikes(context) {
//    Provider.of<PostsProvider>(context)
//        .updatePostLikes(widget.advert.documentID, 'adverts');
//  }

  deleteAdvert(context) {
    Provider.of<PostsProvider>(context).deleteOnePost(
      'adverts',
      widget.advert.documentID,
    );
  }

  callPhoneNumber(phoneNumber) async {
    if (await canLaunch("tel://${phoneNumber.toString()}")) {
      await launch(("tel://${phoneNumber.toString()}"));
    } else {
      throw 'Could not call $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = getLanguages(context);
    final DocumentSnapshot advert = widget.advert;
    final currentUserId = Provider.of<AuthProvider>(context).userId;
    final currentLanguage = Provider.of<LanguageProvider>(context).getLanguage;
    double fontSize = currentLanguage == 'English' ? 15.0 : 17.0;

    return Padding(
      padding: const EdgeInsets.only(
//        bottom: 4.0,
//        top: 2.0,
          ),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 1,
          decoration: BoxDecoration(),
          child: Card(
            elevation: 0.0,
            margin: EdgeInsets.symmetric(
              vertical: 3.0,
              horizontal: 1.0,
            ),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: kSpaceBetween,
                  crossAxisAlignment: kStart,
                  children: <Widget>[
                    cardHeader(advert),
//                    postTypeHolder(
//                      context,
//                      advert['postType'],
//                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    goToDetailsScreen(advert.documentID, advert['title']);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        postTittleHolder(advert['title'].toString(), fontSize),
                        postContent(
                          text: advert['text'].toString(),
                          images: advert['images'],
                          flag: revealMoreTextFlag,
                          onRevealMoreText: _revealMoreText,
                          appLanguage: appLanguage,
                          context: context,
                          imagesScrollView: Axis.horizontal,
                          price: advert['price'].toString(),
                          fontSize: fontSize,
                        ),
                      ],
                    ),
                  ),
                ),
//                postLikesCommentsCountHolder(
//                  post: advert,
//                  appLanguage: appLanguage,
//                  userId: currentUserId,
//                ),
                kHorizontalDivider,
                advertActionButtons(
                  onClickComment: goToDetailsScreen,
                  advertId: advert.documentID,
                  userId: currentUserId,
                  advert: advert,
                  advertTitle: advert['title'],
                  flag: 'posts',
                  onDeleteAdvert: deleteAdvert,
                  onCallPhoneNumber: callPhoneNumber,
                  context: context,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
