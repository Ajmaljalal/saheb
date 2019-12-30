import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';
import '../../providers/postsProvider.dart';
import '../../widgets/fullScreenImage.dart';
import '../../widgets/wait.dart';
import '../../providers/authProvider.dart';
import '../../providers/languageProvider.dart';
import '../../mixins/post.dart';
import '../../languages/index.dart';

class PostDetails extends StatefulWidget {
  final postTitle;
  final postId;

  PostDetails({Key key, this.postTitle, this.postId}) : super(key: key);
  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> with PostMixin {
  bool addCommentFocusFlag = false;
  String _text;

  FocusNode commentFieldFocusNode = FocusNode();

  handleTextInputChange(value) {
    _text = value;
  }

  addCommentTextFieldFocus() {
    FocusScope.of(context).requestFocus(commentFieldFocusNode);
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

  addComment() async {
    final user = await Provider.of<AuthProvider>(context).currentUser;
    if (_text != null && _text.length != 0) {
      final currentUserId =
          Provider.of<AuthProvider>(context, listen: false).userId;
      await Provider.of<PostsProvider>(context, listen: false).addCommentOnPost(
        collection: 'posts',
        postId: widget.postId,
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

  updateCommentLikes(postComment, userId) async {
    final List commentLikes = postComment['likes'];
    if (commentLikes.contains(userId)) {
      return;
    } else {
      await Provider.of<PostsProvider>(context, listen: false)
          .updateCommentLikes(
        collection: 'posts',
        postComment: postComment,
        postId: widget.postId,
        userId: userId,
      );
    }
  }

  deleteComment(postComment) async {
    await Provider.of<PostsProvider>(context, listen: false).deleteComment(
      collection: 'posts',
      postComment: postComment,
      postId: widget.postId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = getLanguages(context);
    final String postTitle = widget.postTitle;
    final String postId = widget.postId;
    final currentUserId = Provider.of<AuthProvider>(context).userId;
    final currentLanguage = Provider.of<LanguageProvider>(context).getLanguage;
    double fontSize = currentLanguage == 'English' ? 15.0 : 17.0;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          title: Text(postTitle != null ? postTitle : ''),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(bottom: 65.0),
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    decoration: BoxDecoration(),
                    child: renderPostContentAndComments(
                      postId: postId,
                      postTitle: postTitle,
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
    );
  }

  renderPostContentAndComments({
    postId,
    postTitle,
    appLanguage,
    userId,
    fontSize,
  }) {
    return StreamBuilder(
      stream: Provider.of<PostsProvider>(context).getOnePost('posts', postId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return wait(appLanguage['wait'], context);
        }
        var post = snapshot.data;
        return Card(
          margin: EdgeInsets.symmetric(vertical: 2.0),
          elevation: 0.0,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  cardHeader(post),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child:
                          postTittleHolder(post['title'], fontSize, context)),
                ],
              ),
              GestureDetector(
                onTap: () {
                  if (post['images'].length > 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImage(
                          images: post['images'],
                          boxFitValue: BoxFit.fitWidth,
                        ),
                      ),
                    );
                  } else {
                    return;
                  }
                },
                child: postContent(
                  text: post['text'],
                  images: post['images'],
                  flag: true,
                  onRevealMoreText: null,
                  appLanguage: appLanguage,
                  context: context,
                  imagesScrollView: Axis.horizontal,
                  fontSize: fontSize,
                ),
              ),
              postLikesCommentsCountHolder(
                post: post,
                appLanguage: appLanguage,
                userId: userId,
                isLiked: post['likes'].contains(userId),
              ),
              Divider(
                color: Colors.grey,
                height: 1,
              ),
              postActionButtons(
                onClickComment: addCommentTextFieldFocus,
                postId: postId,
                userId: userId,
                post: post,
                postTitle: postTitle,
                flag: 'details',
                updateLikes: updateLikes,
                context: context,
                isLiked: post['likes'].contains(userId),
              ),
              Divider(
                color: Colors.grey,
                height: 1,
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    ...individualCommentRenderer(
                      comments: post['comments'],
                      likeComment: updateCommentLikes,
                      deleteComment: deleteComment,
                      userId: userId,
                      postOwnerId: post['owner']['id'],
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
