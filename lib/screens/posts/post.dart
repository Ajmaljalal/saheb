import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:saheb/providers/postsProvider.dart';
import '../../constant_widgets/constants.dart';
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
    Provider.of<PostsProvider>(context).updatePostLikes(widget.post.documentID);
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = getLanguages(context);
    final DocumentSnapshot post = widget.post;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 1,
          decoration: BoxDecoration(),
          child: Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 2.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: kSpaceBetween,
                  crossAxisAlignment: kStart,
                  children: <Widget>[
                    cardHeader(post),
                    postTypeHolder(
                      context,
                      post['type'],
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
                      postTittleHolder(post['title']),
                      postContent(
                        post['text'],
                        post['images'],
                        revealMoreTextFlag,
                        _revealMoreText,
                        appLanguage,
                      ),
                    ],
                  ),
                ),
                postLikesCommentsCountHolder(post, appLanguage),
                kHorizontalDivider,
                postActionButtons(goToDetailsScreen, post.documentID,
                    post['title'], 'post', updateLikes, context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
