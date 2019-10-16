import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import '../../constant_widgets/constants.dart';
import 'advertDetails.dart';
import '../../mixins/post.dart';
import '../../mixins/advert.dart';

class Advert extends StatefulWidget {
  final Map<String, dynamic> advert;
  final String id;
  Advert({Key key, this.advert, this.id}) : super(key: key);

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

  goToDetailsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdvertDetails(id: widget.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final advert = widget.advert;
    return Padding(
      padding: const EdgeInsets.only(top: 3.0),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 1,
          decoration: BoxDecoration(),
          child: Card(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: kSpaceBetween,
                  crossAxisAlignment: kStart,
                  children: <Widget>[
                    cardHeader(advert),
                    postTypeHolder(
                      context,
                      advert['postType'],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    goToDetailsScreen();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      postTittleHolder(advert['postTitle']),
                      postContent(
                        advert['postText'],
                        advert['postPictures'],
                        revealMoreTextFlag,
                        _revealMoreText,
                      ),
                    ],
                  ),
                ),
                postLikesCommentsCountHolder(
                    advert['postLikes'], advert['postComments']),
                kHorizontalDivider,
                advertActionButtons(goToDetailsScreen, context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
