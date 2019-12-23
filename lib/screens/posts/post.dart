import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:saheb/providers/postsProvider.dart';
import 'package:saheb/util/deleteImages.dart';
import 'package:saheb/widgets/emptyBox.dart';
import '../../widgets/showInfoFushbar.dart';
import '../../providers/authProvider.dart';
import '../../providers/languageProvider.dart';

import '../../constants/constants.dart';
import '../../widgets/flatButtonWithIconAndText.dart';
import 'postDetails.dart';
import '../add_posts/none_advert_post.dart';
import '../../mixins/post.dart';
import '../../languages/index.dart';

class Post extends StatefulWidget {
  final post;
  final postId;
  final usersProvince;
  Post({Key key, this.post, this.postId, this.usersProvince}) : super(key: key);

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

  renderFlashBar(message) {
    showInfoFlushbar(
      context: context,
      duration: 2,
      message: message,
      icon: Icons.check_circle,
      progressBar: false,
      positionTop: false,
    );
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

  updateLikes({
    List postLikes,
    userId,
    isLiked,
  }) {
    Provider.of<PostsProvider>(context).updatePostLikes(
      widget.postId,
      'posts',
      userId,
      isLiked,
    );
  }

  deletePost(message, images) {
    Provider.of<PostsProvider>(context)
        .deleteOneRecord(widget.postId, 'posts', images);
    Navigator.pop(context);
    renderFlashBar(message);
  }

  favoriteAPost(userId, message, isFavorite) {
    Provider.of<PostsProvider>(context)
        .favoriteAPost(widget.postId, 'posts', userId, isFavorite);
    Navigator.pop(context);
    renderFlashBar(message);
  }

  hideAPost(userId, message) async {
    await Provider.of<PostsProvider>(context)
        .hideAPost(widget.postId, 'posts', userId);
    Navigator.pop(context);
    renderFlashBar(message);
  }

  reportAPost(message) async {
    await Provider.of<PostsProvider>(context)
        .reportAPost(widget.post, widget.postId);
    Navigator.pop(context);
    renderFlashBar(message);
  }

  editPost(post, postId) {
    final province = widget.usersProvince;
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoneAdvertPost(
          type: post['type'],
          edit: true,
          post: post,
          postId: postId,
          province: province,
        ),
      ),
    );
  }

  closeBottomSheet() {}

  @override
  Widget build(BuildContext context) {
    final appLanguage = getLanguages(context);
    final post = widget.post;
    final postId = widget.postId;
    final currentUserId = Provider.of<AuthProvider>(context).userId;
    final currentLanguage = Provider.of<LanguageProvider>(context).getLanguage;
    double fontSize = currentLanguage == 'English' ? 14.0 : 17.0;

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        decoration: BoxDecoration(),
        child: Card(
          elevation: 0.0,
          color: Colors.white,
          margin: const EdgeInsets.symmetric(
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
                    postOwnerId: post['owner']['id'],
                    currentUserId: currentUserId,
                    isFavorite: post['favorites'].contains(currentUserId),
                    postImages: post['images'],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  goToDetailsScreen(postId, post['title']);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    postTittleHolder(post['title'], fontSize, context),
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
                        postDate: post['date']),
                  ],
                ),
              ),
              postLikesCommentsCountHolder(
                post: post,
                appLanguage: appLanguage,
                userId: currentUserId,
                isLiked:
                    widget.post['likes'].contains(currentUserId) ? true : false,
              ),
              kHorizontalDivider,
              postActionButtons(
                onClickComment: goToDetailsScreen,
                postId: widget.postId,
                userId: currentUserId,
                post: post,
                postTitle: post['title'],
                flag: 'post',
                updateLikes: updateLikes,
                context: context,
                isLiked:
                    widget.post['likes'].contains(currentUserId) ? true : false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  showPostOptions(
    context,
    appLanguage,
    currentUserId,
    postOwnerId,
    isFavorite,
    postImages,
  ) {
    bool postOwner = currentUserId == postOwnerId ? true : false;
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 2.0,
        ),
        padding: const EdgeInsets.symmetric(
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
              onPressed: () {
                this.favoriteAPost(
                  currentUserId,
                  appLanguage['postSaved'],
                  isFavorite,
                );
              },
            ),
            postOwner
                ? flatButtonWithIconAndText(
                    text: appLanguage['editPost'],
                    subText: appLanguage['editPostSubText'],
                    icon: Icons.edit,
                    color: Colors.purpleAccent,
                    onPressed: () {
                      this.editPost(widget.post, widget.postId);
                    })
                : emptyBox(),
            !postOwner
                ? flatButtonWithIconAndText(
                    text: appLanguage['reportPost'],
                    subText: appLanguage['reportPostSubText'],
                    icon: Icons.report,
                    color: Colors.red,
                    onPressed: () {
                      this.reportAPost(appLanguage['postReported']);
                    })
                : emptyBox(),
            !postOwner
                ? flatButtonWithIconAndText(
                    text: appLanguage['hidePost'],
                    subText: appLanguage['hidePostSubText'],
                    icon: Icons.block,
                    color: Colors.grey,
                    onPressed: () {
                      this.hideAPost(currentUserId, appLanguage['postHide']);
                    })
                : emptyBox(),
            postOwner
                ? flatButtonWithIconAndText(
                    text: appLanguage['deletePost'],
                    subText: appLanguage['deletePostSubText'],
                    icon: Icons.delete,
                    color: Colors.red,
                    onPressed: () {
                      this.deletePost(appLanguage['postDeleted'], postImages);
                    })
                : emptyBox(),
          ],
        ),
      ),
    );
  }
}
