import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../store/store.dart';
import 'post.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  @override
  Widget build(BuildContext context) {
    Map _posts = Provider.of<Store>(context).getPosts;

    return ListView.builder(
      itemBuilder: (context, index) {
        var id = _posts.keys.toList().elementAt(index);
        var post = _posts[id];
        return Post(post: post);
      },
      itemCount: _posts.keys.length,
    );
  }
}
