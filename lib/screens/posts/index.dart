//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import '../../providers/authProvider.dart';
import '../../providers/postsProvider.dart';
import 'post.dart';

class Posts extends StatefulWidget {
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  Widget build(BuildContext context) {
//    var _currentUser;
//    Provider.of<AuthProvider>(context).currentUser.then((user) {
//      _currentUser = user;
//    });

    return StreamBuilder(
      stream: Provider.of<PostsProvider>(context).getAllPosts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: Text("Loading.."));
        }

//        if (snapshot.data.documents.toList().length == 0) {
//          return Center(
//            child: Text(
//                'No posts exit, add post by clicking the add(+) button above'),
//          );
//        }
        return ListView.builder(
          itemBuilder: (context, index) {
            var post = snapshot.data.documents[index];
            return Post(post: post);
          },
          itemCount: snapshot.data.documents.length,
        );
      },
    );
  }
}
