import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import '../../constant_widgets/constants.dart';
import 'postDetails.dart';
import '../../mixins/post.dart';

class Post extends StatefulWidget {
  final Map<String, dynamic> post;
  final String id;
  Post({Key key, this.post, this.id}) : super(key: key);

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

  goToDetailsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetails(id: widget.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return Padding(
      padding: const EdgeInsets.only(top: 3.0),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 1,
          decoration: BoxDecoration(),
          child: Card(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: kSpaceBetween,
                  crossAxisAlignment: kStart,
                  children: <Widget>[
                    cardHeader(post),
                    postTypeHolder(
                      context,
                      post['postType'],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    goToDetailsScreen();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      postTittleHolder(post['postTitle']),
                      postContent(
                        post['postText'],
                        post['postPictures'],
                        revealMoreTextFlag,
                        _revealMoreText,
                      ),
                    ],
                  ),
                ),
                postLikesCommentsCountHolder(
                    post['postLikes'], post['postComments']),
                kHorizontalDivider,
                postActionButtons(goToDetailsScreen),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
