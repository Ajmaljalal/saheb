import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:saheb/providers/postsProvider.dart';
import 'package:saheb/widgets/emptyBox.dart';
import '../../providers/authProvider.dart';
import '../../providers/languageProvider.dart';

import '../../constants/constants.dart';
import '../../widgets/flatButtonWithIconAndText.dart';
import 'postDetails.dart';
import '../../mixins/post.dart';
import '../../languages/index.dart';

class Post extends StatefulWidget {
  final DocumentSnapshot post;
  Post({Key key, this.post}) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> with PostMixin {
  bool revealMoreTextFlag = false;

  _revealMoreText() {
    setState(() {
      revealMoreTextFlag = !revealMoreTextFlag;
    });
  }

  goToDetailsScreen(postId, postTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetails(
          postTitle: postTitle,
          postId: postId,
        ),
      ),
    );
  }

  updateLikes(context) {
    Provider.of<PostsProvider>(context)
        .updatePostLikes(widget.post.documentID, 'posts');
  }

  deletePost(context) {
    Provider.of<PostsProvider>(context)
        .deleteOnePost(widget.post.documentID, 'posts');
  }

  closeBottomSheet() {}

  showPostOptions(context, appLanguage, currentUserId, postId) {
    bool postOwner = currentUserId == postId ? true : false;
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        margin: EdgeInsets.symmetric(
          horizontal: 2.0,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 5.0,
          vertical: 10.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10.0),
            topLeft: Radius.circular(10.0),
          ),
        ),
        height: 200.0,
        child: Column(
          children: <Widget>[
            Container(
              width: 50.0,
              height: 5.0,
              color: Colors.grey,
              margin: EdgeInsets.only(
                bottom: 15.0,
              ),
            ),
            flatButtonWithIconAndText(
              text: appLanguage['savePost'],
              subText: appLanguage['savePostSubText'],
              icon: Icons.bookmark,
              color: Colors.green,
              onPressed: () {},
            ),
            postOwner
                ? flatButtonWithIconAndText(
                    text: appLanguage['editPost'],
                    subText: appLanguage['editPostSubText'],
                    icon: Icons.edit,
                    color: Colors.purpleAccent,
                    onPressed: () {})
                : emptyBox(),
            !postOwner
                ? flatButtonWithIconAndText(
                    text: appLanguage['reportPost'],
                    subText: appLanguage['reportPostSubText'],
                    icon: Icons.report,
                    color: Colors.red,
                    onPressed: () {})
                : emptyBox(),
            !postOwner
                ? flatButtonWithIconAndText(
                    text: appLanguage['hidePost'],
                    subText: appLanguage['hidePostSubText'],
                    icon: Icons.block,
                    color: Colors.grey,
                    onPressed: () {})
                : emptyBox(),
            postOwner
                ? flatButtonWithIconAndText(
                    text: appLanguage['deletePost'],
                    subText: appLanguage['deletePostSubText'],
                    icon: Icons.delete,
                    color: Colors.blueAccent,
                    onPressed: () {})
                : emptyBox(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = getLanguages(context);
    final DocumentSnapshot post = widget.post;
    final currentUserId = Provider.of<AuthProvider>(context).userId;
    final currentLanguage = Provider.of<LanguageProvider>(context).getLanguage;
    double fontSize = currentLanguage == 'English' ? 15.0 : 17.0;

    return Padding(
      padding: const EdgeInsets.only(
//        bottom: 1.0,
//        top: 2.0,
          ),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 1,
          decoration: BoxDecoration(),
          child: Card(
            elevation: 0.0,
            color: Colors.white,
            margin: EdgeInsets.symmetric(
              vertical: 3.0,
              horizontal: 1.0,
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: kSpaceBetween,
                  crossAxisAlignment: kStart,
                  children: <Widget>[
                    cardHeader(post),
                    postOptions(
                      context: context,
                      onOpenOptions: showPostOptions,
                      appLanguage: appLanguage,
                      postId: post['owner']['id'],
                      currentUserId: currentUserId,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    goToDetailsScreen(post.documentID, post['title']);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      postTittleHolder(post['title'], fontSize),
                      postTypeHolder(context, post['type'], appLanguage),
                      postContent(
                        text: post['text'],
                        images: post['images'],
                        flag: revealMoreTextFlag,
                        onRevealMoreText: _revealMoreText,
                        appLanguage: appLanguage,
                        context: context,
                        imagesScrollView: Axis.horizontal,
                        fontSize: fontSize,
                      ),
                    ],
                  ),
                ),
                postLikesCommentsCountHolder(
                  post: post,
                  appLanguage: appLanguage,
                  userId: currentUserId,
                ),
                kHorizontalDivider,
                postActionButtons(
                  onClickComment: goToDetailsScreen,
                  postId: post.documentID,
                  userId: currentUserId,
                  post: post,
                  postTitle: post['title'],
                  flag: 'post',
                  updateLikes: updateLikes,
                  onDeletePost: deletePost,
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
