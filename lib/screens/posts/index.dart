import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import '../../providers/authProvider.dart';
import '../../providers/postsProvider.dart';
import '../../languages/index.dart';
import 'post.dart';

class Posts extends StatefulWidget {
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  Widget build(BuildContext context) {
    final appLanguage = getLanguages(context);
//    var _currentUser;
//    Provider.of<AuthProvider>(context).currentUser.then((user) {
//      _currentUser = user;
//    });

    return StreamBuilder(
      stream: Provider.of<PostsProvider>(context).getAllPosts('posts'),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: Text(appLanguage['wait']));
        }
        if (snapshot.data.documents.toList().length == 0) {
          return Center(
            child: Text(
              appLanguage['noContent'],
            ),
          );
        }
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
