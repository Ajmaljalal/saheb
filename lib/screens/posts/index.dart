import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/authProvider.dart';
import '../../providers/postsProvider.dart';
import 'post.dart';

class Posts extends StatefulWidget {
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  Widget build(BuildContext context) {
    Map _posts = Provider.of<PostsProvider>(context).getPosts;
    var _currentUser;
    Provider.of<AuthProvider>(context).currentUser.then((user) {
      _currentUser = user;
    });

    return ListView.builder(
      itemBuilder: (context, index) {
        var id = _posts.keys.toList().elementAt(index);
        var post = _posts[id];
        return Post(post: post, id: id);
      },
      itemCount: _posts.keys.length,
    );
  }
}
