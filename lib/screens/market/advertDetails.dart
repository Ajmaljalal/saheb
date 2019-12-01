import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:saheb/providers/postsProvider.dart';
import 'package:saheb/widgets/emptyBox.dart';
import 'package:saheb/widgets/horizontalDividerIndented.dart';
import 'package:saheb/widgets/wait.dart';
import '../../providers/authProvider.dart';
import '../../providers/languageProvider.dart';
import '../../mixins/post.dart';
import '../../mixins/advert.dart';
import '../../languages/index.dart';
import 'package:saheb/widgets/fullScreenImage.dart';

class AdvertDetails extends StatefulWidget {
  final advertTitle;
  final advertId;
  AdvertDetails({Key key, this.advertId, this.advertTitle}) : super(key: key);
  @override
  _AdvertDetailsState createState() => _AdvertDetailsState();
}

class _AdvertDetailsState extends State<AdvertDetails>
    with PostMixin, AdvertMixin {
  bool addCommentFocusFlag = false;
  String _text;
  FocusNode commentFieldFocusNode = FocusNode();

  handleTextInputChange(value) {
    _text = value;
  }

  addCommentTextFieldFocus() {
    FocusScope.of(context).requestFocus(commentFieldFocusNode);
  }

  addComment() async {
    final user = await Provider.of<AuthProvider>(context).currentUser;
    if (_text != null && _text.length != 0) {
      final currentUserId =
          Provider.of<AuthProvider>(context, listen: false).userId;
      await Provider.of<PostsProvider>(context, listen: false).addCommentOnPost(
        collection: 'adverts',
        postId: widget.advertId,
        text: _text,
        user: {
          'name': user.displayName,
          'id': currentUserId,
          'photo': user.photoUrl,
          'location': 'some location'
        },
      );
    } else
      return;

    FocusScope.of(context).unfocus();
  }

  clearAddCommentTextField() {
    FocusScope.of(context).unfocus();
    _text = '';
  }

  updateCommentLikes(advertComment) async {
    await Provider.of<PostsProvider>(context, listen: false).updateCommentLikes(
      collection: 'adverts',
      postComment: advertComment,
      postId: widget.advertId,
    );
  }

  deleteComment(postComment) async {
    await Provider.of<PostsProvider>(context, listen: false).deleteComment(
      collection: 'adverts',
      postComment: postComment,
      postId: widget.advertId,
    );
  }

  deletePost(context) async {
    await Provider.of<PostsProvider>(context).deleteOnePost(
      'advert',
      widget.advertId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = getLanguages(context);
    final String advertTitle = widget.advertTitle.toString();
    final String advertId = widget.advertId;
    final currentUserId = Provider.of<AuthProvider>(context).userId;
    final currentLanguage = Provider.of<LanguageProvider>(context).getLanguage;
    double fontSize = currentLanguage == 'English' ? 15.0 : 17.0;
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(),
        ),
        body: renderAdvertContent(
          advertId: advertId,
          advertTitle: advertTitle,
          appLanguage: appLanguage,
          userId: currentUserId,
          fontSize: fontSize,
        ),
      ),
    );
  }

  Widget renderAdvertContent({
    advertId,
    advertTitle,
    appLanguage,
    userId,
    fontSize,
  }) {
    return StreamBuilder(
      stream:
          Provider.of<PostsProvider>(context).getOnePost('adverts', advertId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return wait(appLanguage['wait'], context);
        }
        var advert = snapshot.data;
        return Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width * 1,
                        minHeight: MediaQuery.of(context).size.height * 1,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              if (advert['images'].length > 0) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenImage(
                                      images: advert['images'],
                                    ),
                                  ),
                                );
                              } else {
                                return;
                              }
                            },
                            child: advert['images'].length > 0
                                ? postImages(
                                    images: advert['images'],
                                    context: context,
                                    scrollView: Axis.horizontal,
                                  )
                                : emptyBox(),
                          ),
                          const SizedBox(height: 5.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              postTittleHolder(advert['title'].toString(),
                                  fontSize, context),
                              Container(
                                margin: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  advert['price'],
                                  style: TextStyle(
                                    color: Colors.cyan,
                                    fontSize: 20.0,
                                  ),
                                ),
                              )
                            ],
                          ),
                          horizontalDividerIndented(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              advertDetails(appLanguage['locationHolder'],
                                  advert['location']),
                              advertDetails(
                                  appLanguage['typeOfDeal'], advert['type']),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              advertDetails(appLanguage['phoneNumber'],
                                  advert['phone'].toString()),
                              advertDetails(appLanguage['date'], '11/30/2019'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              advertDetails(appLanguage['email'],
                                  advert['email'].toString()),
                            ],
                          ),
                          horizontalDividerIndented(),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(advert['text'].toString()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0.0,
              right: 0,
              left: 0,
              child: advertOwnersDetails(
                advert['owner'],
                advert['phone'],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget advertDetails(forText, text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '$forText:  ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              text.toString() != 'null' ? Text(text) : Text('---'),
            ],
          ),
        ],
      ),
    );
  }

  Widget advertOwnersDetails(owner, phoneNumber) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.cyanAccent,
            width: 0.5,
          ),
        ),
        color: Colors.white,
      ),
      height: MediaQuery.of(context).size.height * 0.08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            'User info and user',
            style: TextStyle(color: Colors.black),
          ),
          Material(
            child: Container(
              child: IconButton(
                icon: Icon(FontAwesomeIcons.comments),
                onPressed: () {},
              ),
            ),
          ),
          Material(
            child: Container(
              child: IconButton(
                icon: Icon(FontAwesomeIcons.phone),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
