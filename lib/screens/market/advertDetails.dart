import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../store/store.dart';
import '../../mixins/post.dart';
import '../../mixins/advert.dart';

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
    Map posts = Provider.of<Store>(context).getPosts;
    Map post = posts[widget.id];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(post['postTitle'])),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: <Widget>[
              Container(),
              SingleChildScrollView(
                child: Container(
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
                                  cardHeader(post),
                                  postTypeHolder(context, post['postType']),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  postTittleHolder(post['postTitle']),
                                ],
                              ),
                              postContent(
                                post['postText'],
                                [],
                                true,
                                null,
                              ),
                              postLikesCommentsCountHolder(
                                post['postLikes'],
                                post['postComments'],
                              ),
                              Divider(
                                color: Colors.grey,
                                height: 1,
                              ),
                              advertActionButtons(addCommentTextFieldFocus),
                              Divider(
                                color: Colors.grey,
                                height: 1,
                              ),
                              individualCommentRenderer(post['postComments']),
                              individualCommentRenderer(post['postComments']),
                              individualCommentRenderer(post['postComments']),
                            ],
                          ),
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
                child: addCommentTextField(commentFieldFocusNode),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
