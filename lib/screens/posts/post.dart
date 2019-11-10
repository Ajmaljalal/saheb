import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:saheb/providers/postsProvider.dart';
import '../../providers/authProvider.dart';

import '../../constants/constants.dart';
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

  @override
  Widget build(BuildContext context) {
    final appLanguage = getLanguages(context);
    final DocumentSnapshot post = widget.post;
    final currentUserId = Provider.of<AuthProvider>(context).userId;

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
                      postTypeHolder(context, post['type'], appLanguage),
                      postContent(
                        text: post['text'],
                        images: post['images'],
                        flag: revealMoreTextFlag,
                        onRevealMoreText: _revealMoreText,
                        appLanguage: appLanguage,
                        context: context,
                        imagesScrollView: Axis.horizontal,
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
