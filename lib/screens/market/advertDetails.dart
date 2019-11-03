import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../providers/adverts.dart';
import '../../mixins/post.dart';
import '../../mixins/advert.dart';
import '../../languages/index.dart';

class AdvertDetails extends StatefulWidget {
  final String id;
  AdvertDetails({Key key, this.id}) : super(key: key);
  @override
  _AdvertDetailsState createState() => _AdvertDetailsState();
}

class _AdvertDetailsState extends State<AdvertDetails>
    with PostMixin, AdvertMixin {
  bool addCommentFocusFlag = false;

  FocusNode commentFieldFocusNode = FocusNode();
  addCommentTextFieldFocus() {
    FocusScope.of(context).requestFocus(commentFieldFocusNode);
  }

  @override
  Widget build(BuildContext context) {
    Map adverts = Provider.of<Adverts>(context).getAdverts;
    final appLanguage = getLanguages(context);
    Map advert = adverts[widget.id];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(advert['postTitle'])),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: <Widget>[
              Container(),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(bottom: 65.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 1,
                        decoration: BoxDecoration(),
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  cardHeader(advert),
                                  postTypeHolder(context, advert['postType']),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  postTittleHolder(advert['postTitle']),
                                ],
                              ),
                              postContent(
                                text: advert['postText'],
                                images: advert['postPictures'],
                                flag: true,
                                onRevealMoreText: null,
                                appLanguage: appLanguage,
                              ),
//                              postLikesCommentsCountHolder(
//                                advert['postLikes'],
//                                advert['postComments'],
//                                appLanguage,
//                              ),
                              Divider(
                                color: Colors.grey,
                                height: 1,
                              ),
                              advertActionButtons(
                                  addCommentTextFieldFocus, context),
                              Divider(
                                color: Colors.grey,
                                height: 1,
                              ),
//                              individualCommentRenderer(advert['postComments']),
//                              individualCommentRenderer(advert['postComments']),
//                              individualCommentRenderer(advert['postComments']),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
//              Positioned(
////                bottom: 0.0,
////                right: 0,
////                left: 0,
////                child: addCommentTextField(
////                  commentFieldFocusNode,
////                  appLanguage,
////                ),
////              ),
            ],
          ),
        ),
      ),
    );
  }
}
