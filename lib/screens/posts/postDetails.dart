import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saheb/providers/postsProvider.dart';
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
    await Provider.of<PostsProvider>(context, listen: false).addCommentOnPost(
      postId: widget.postId,
      text: _text,
      user: {'name': 'namehere'},
    );
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = getLanguages(context);
    final String postTitle = widget.postTitle;
    final String postId = widget.postId;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(postTitle)),
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
                        child: renderPostContentAndComments(
                            postId, postTitle, appLanguage),
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
                    onSubmit: addComment),
              ),
            ],
          ),
        ),
      ),
    );
  }

  renderPostContentAndComments(postId, postTitle, appLanguage) {
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
              postContent(
                post['text'],
                [],
                true,
                null,
                appLanguage,
              ),
              postLikesCommentsCountHolder(
                post,
                appLanguage,
              ),
              Divider(
                color: Colors.grey,
                height: 1,
              ),
              postActionButtons(addCommentTextFieldFocus, postId, postTitle,
                  'details', updateLikes, context),
              Divider(
                color: Colors.grey,
                height: 1,
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    ...individualCommentRenderer(post['comments']),
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
