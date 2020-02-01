import 'package:com.pywast.pywast/widgets/wait.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'postDetails.dart';
import '../../providers/postsProvider.dart';
import '../../widgets/emptyBox.dart';
import '../../widgets/showInfoFushbar.dart';
import '../../providers/authProvider.dart';
import '../../providers/languageProvider.dart';
import '../../constants/constants.dart';
import '../../widgets/flatButtonWithIconAndText.dart';
import '../add_posts/none_advert_post.dart';
import '../../mixins/post.dart';
import '../../languages/index.dart';

class Post extends StatefulWidget {
  final postId;
  final usersProvince;
  Post({
    Key key,
    this.postId,
    this.usersProvince,
  }) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> with PostMixin {
  bool revealMoreTextFlag = false;
  bool postDeleting = false;

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
    Provider.of<PostsProvider>(context, listen: false).updatePostLikes(
      widget.postId,
      'posts',
      userId,
      isLiked,
    );
  }

  deletePost(message, images) async {
    setState(() {
      postDeleting = true;
    });
    Provider.of<PostsProvider>(context)
        .deleteOneRecord(widget.postId, 'ids_posts', null);

    Navigator.pop(context);

    await Provider.of<PostsProvider>(context)
        .deleteOneRecord(widget.postId, 'posts', images);
    renderFlashBar(message);

    setState(() {
      postDeleting = false;
    });
  }

  favoriteAPost(userId, message, isFavorite) {
    Provider.of<PostsProvider>(context, listen: false)
        .favoriteAPost(widget.postId, 'posts', userId, isFavorite);
    Navigator.pop(context);
    renderFlashBar(message);
  }

  hideAPost(userId, message) async {
    await Provider.of<PostsProvider>(context, listen: false)
        .hideAPost(widget.postId, 'posts', userId);
    Navigator.pop(context);
    renderFlashBar(message);
  }

  reportAPost(message, post) async {
    await Provider.of<PostsProvider>(context, listen: false)
        .reportAPost(post, widget.postId);
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
          edit: true,
          post: post,
          postId: postId,
          province: province,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = getLanguages(context);
    final postId = widget.postId;
    final currentUserId =
        Provider.of<AuthProvider>(context, listen: false).userId;
    final currentLanguage =
        Provider.of<LanguageProvider>(context, listen: false).getLanguage;
    double fontSize = currentLanguage == 'English' ? 14.0 : 17.0;
    return _buildContent(
      appLanguage: appLanguage,
      postId: postId,
      currentUserId: currentUserId,
      fontSize: fontSize,
    );
  }

  Widget _buildContent({
    appLanguage,
    postId,
    currentUserId,
    fontSize,
  }) {
    return postDeleting == false
        ? StreamBuilder(
            stream:
                Provider.of<PostsProvider>(context).getOnePost('posts', postId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return wait(appLanguage['wait'], context);
              }
              var _post = snapshot.data;
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
                            cardHeader(_post),
                            postOptions(
                              context: context,
                              onOpenOptions: showPostOptions,
                              appLanguage: appLanguage,
                              postOwnerId: _post['owner']['id'],
                              currentUserId: currentUserId,
                              isFavorite:
                                  _post['favorites'].contains(currentUserId),
                              postImages: _post['images'],
                              post: _post,
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            goToDetailsScreen(postId, _post['title']);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              postTittleHolder(
                                  _post['title'], fontSize, context),
                              postContent(
                                  text: _post['text'],
                                  images: _post['images'],
                                  flag: revealMoreTextFlag,
                                  onRevealMoreText: _revealMoreText,
                                  appLanguage: appLanguage,
                                  context: context,
                                  imagesScrollView: Axis.horizontal,
                                  fontSize: fontSize,
                                  postDate: _post['date']),
                            ],
                          ),
                        ),
                        postLikesCommentsCountHolder(
                          post: _post,
                          appLanguage: appLanguage,
                          userId: currentUserId,
                          isLiked: _post['likes'].contains(currentUserId)
                              ? true
                              : false,
                        ),
                        kHorizontalDivider,
                        postActionButtons(
                          onClickComment: goToDetailsScreen,
                          postId: widget.postId,
                          userId: currentUserId,
                          post: _post,
                          postTitle: _post['title'],
                          flag: 'post',
                          updateLikes: updateLikes,
                          context: context,
                          isLiked: _post['likes'].contains(currentUserId)
                              ? true
                              : false,
                        ),
                      ],
                    ),
                  ),
                ),
              );
              ;
            },
          )
        : emptyBox();
  }

  showPostOptions(
    context,
    appLanguage,
    currentUserId,
    postOwnerId,
    isFavorite,
    postImages,
    post,
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
          borderRadius: const BorderRadius.only(
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
              margin: const EdgeInsets.only(
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
                      this.editPost(post, widget.postId);
                    })
                : emptyBox(),
            !postOwner
                ? flatButtonWithIconAndText(
                    text: appLanguage['reportPost'],
                    subText: appLanguage['reportPostSubText'],
                    icon: Icons.report,
                    color: Colors.red,
                    onPressed: () {
                      this.reportAPost(appLanguage['postReported'], post);
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
