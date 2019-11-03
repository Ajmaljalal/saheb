import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saheb/providers/postsProvider.dart';
import 'package:saheb/widgets/fullScreenImage.dart';
import '../../providers/authProvider.dart';
import 'package:flutter/widgets.dart';
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

  updateLikes(context) {
    Provider.of<PostsProvider>(context, listen: false)
        .updatePostLikes(widget.postId);
  }

  addComment() async {
    final user = await Provider.of<AuthProvider>(context).currentUser;
    if (_text != null && _text.length != 0) {
      final currentUserId =
          Provider.of<AuthProvider>(context, listen: false).userId;
      await Provider.of<PostsProvider>(context, listen: false).addCommentOnPost(
        postId: widget.postId,
        text: _text,
        user: {
          'name': user.displayName,
          'id': currentUserId,
          'photo': user.photoUrl,
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

  updateCommentLikes(postComment) async {
    await Provider.of<PostsProvider>(context, listen: false)
        .updateCommentLikes(postComment: postComment, postId: widget.postId);
  }

  deleteComment(postComment) async {
    await Provider.of<PostsProvider>(context, listen: false)
        .deleteComment(postComment: postComment, postId: widget.postId);
  }

  deletePost(context) async {
    await Provider.of<PostsProvider>(context).deleteOnePost(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = getLanguages(context);
    final String postTitle = widget.postTitle;
    final String postId = widget.postId;
    final currentUserId = Provider.of<AuthProvider>(context).userId;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(postTitle)),
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
    postId,
    postTitle,
    appLanguage,
    userId,
  }) {
    return StreamBuilder(
      stream: Provider.of<PostsProvider>(context).getOnePost(postId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text("Loading..");
        }
        var post = snapshot.data;
        return Card(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  cardHeader(post),
                  postTypeHolder(context, post['type']),
                ],
              ),
              Row(
                children: <Widget>[
                  postTittleHolder(post['title']),
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
                ),
              ),
              postLikesCommentsCountHolder(
                post: post,
                appLanguage: appLanguage,
                userId: userId,
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
                onDeletePost: deletePost,
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
