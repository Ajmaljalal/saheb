import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saheb/providers/postsProvider.dart';
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

  updateLikes(context) {
    Provider.of<PostsProvider>(context, listen: false)
        .updatePostLikes(widget.advertId, 'adverts');
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
        appBar: AppBar(title: Text(advertTitle)),
        body: Stack(
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
                      child: renderPostContentAndComments(
                        advertId: advertId,
                        advertTitle: advertTitle,
                        appLanguage: appLanguage,
                        userId: currentUserId,
                        fontSize: fontSize,
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
              child: addCommentTextField(
                focusNode: commentFieldFocusNode,
                appLanguage: appLanguage,
                onChange: handleTextInputChange,
                onSubmit: addComment,
                userId: currentUserId,
                onClearTextField: clearAddCommentTextField,
                context: context,
              ),
            ),
          ],
        ),
      ),
    );
  }

  renderPostContentAndComments({
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
          return Text("Loading..");
        }
        var advert = snapshot.data;
        return Card(
          elevation: 0.0,
          margin: EdgeInsets.symmetric(
            vertical: 3.0,
          ),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  cardHeader(advert),
                ],
              ),
              Row(
                children: <Widget>[
                  postTittleHolder(advert['title'].toString(), fontSize),
                ],
              ),
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
                child: postContent(
                  text: advert['text'].toString(),
                  images: advert['images'],
                  flag: true,
                  onRevealMoreText: null,
                  appLanguage: appLanguage,
                  context: context,
                  imagesScrollView: Axis.horizontal,
                  fontSize: fontSize,
                ),
              ),
              postLikesCommentsCountHolder(
                post: advert,
                appLanguage: appLanguage,
                userId: userId,
              ),
              Divider(
                color: Colors.grey,
                height: 1,
              ),
              advertActionButtons(
                onClickComment: addCommentTextFieldFocus,
                advertId: advertId,
                userId: userId,
                advert: advert,
                advertTitle: advertTitle,
                flag: 'details',
                updateLikes: updateLikes,
                context: context,
                onDeleteAdvert: deletePost,
              ),
              Divider(
                color: Colors.grey,
                height: 1,
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    ...individualCommentRenderer(
                      comments: advert['comments'],
                      likeComment: updateCommentLikes,
                      deleteComment: deleteComment,
                      userId: userId,
                      postOwnerId: advert['owner']['id'],
                      context: context,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
