import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:saheb/providers/authProvider.dart';
import 'package:saheb/providers/locationProvider.dart';
import 'package:saheb/widgets/noContent.dart';
import '../../providers/postsProvider.dart';
import '../../languages/index.dart';
import 'post.dart';

class Posts extends StatefulWidget {
  final searchBarString;
  final usersProvince;
  Posts({Key key, this.searchBarString, this.usersProvince}) : super(key: key);
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  String currentFilterOption;
  int currentOptionId = 1;

  handleFilterOptionsChange(text, id) {
    setState(() {
      currentFilterOption = text;
      currentOptionId = id;
    });
  }

  filterPosts(List posts, appLanguage, currentUserId, appBarSearchString) {
    var filteredPosts = posts;
    if (appBarSearchString != null) {
      filteredPosts = posts
          .where(
            (post) =>
                post['title']
                    .toString()
                    .contains(appBarSearchString.toString()) ||
                post['text']
                    .toString()
                    .contains(appBarSearchString.toString()) ||
                post['type'].toString().contains(appBarSearchString.toString()),
          )
          .toList();
    }
    if (currentFilterOption.toLowerCase() == 'افغانستان') {
      return filteredPosts;
    }

    if (currentFilterOption == appLanguage['myPosts']) {
      filteredPosts = filteredPosts
          .where((post) =>
              post['owner']['id'].toString() == currentUserId.toString())
          .toList();
      return filteredPosts;
    }

    filteredPosts = filteredPosts
        .where((post) => post['location']
            .toString()
            .toLowerCase()
            .contains(currentFilterOption.toLowerCase()))
        .toList();
    return filteredPosts;
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = getLanguages(context);
    final currentUserId = Provider.of<AuthProvider>(context).userId;
    final userLocation = Provider.of<LocationProvider>(context).getLocation;
    if (currentFilterOption == null) {
      setState(() {
        currentFilterOption = userLocation;
      });
    }
    return screenContent(appLanguage, currentUserId, userLocation);
  }

  Widget screenContent(appLanguage, currentUserId, userLocation) {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: <Widget>[
          filterOptions(appLanguage, userLocation),
          StreamBuilder(
            stream: Provider.of<PostsProvider>(context).getAllPosts('posts'),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return noContent(appLanguage, context);
              }
              if (snapshot.data.documents.toList().length == 0) {
                return noContent(appLanguage, context);
              }
              List<DocumentSnapshot> tempList = snapshot.data.documents;
              List<Map<dynamic, dynamic>> posts = List();
              posts = tempList.map((DocumentSnapshot docSnapshot) {
                return docSnapshot.data;
              }).toList();

              var filteredPosts = filterPosts(
                  posts, appLanguage, currentUserId, widget.searchBarString);

              return filteredPosts.length > 0
                  ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filteredPosts.length,
                      itemBuilder: (context, index) {
                        final postId =
                            snapshot.data.documents[index].documentID;
                        var post = filteredPosts.toList()[index];
                        return Post(post: post, postId: postId);
                      },
                    )
                  : noContent(appLanguage, context);
            },
          ),
        ],
      ),
    );
  }

  Widget filterOptions(appLanguage, userLocation) {
    return SingleChildScrollView(
      child: Container(
        height: 40.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            filterOption(userLocation, 1),
            filterOption(widget.usersProvince, 2),
            filterOption('افغانستان', 3),
            filterOption(appLanguage['myPosts'], 4),
            filterOption(appLanguage['myFavorites'], 5),
          ],
        ),
      ),
    );
  }

  Widget filterOption(text, id) {
    return GestureDetector(
      onTap: () => handleFilterOptionsChange(text, id),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: id == currentOptionId ? Colors.greenAccent[700] : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[400],
              blurRadius: 5.0,
            )
          ],
        ),
        constraints: const BoxConstraints(
          minWidth: 50.0,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        margin: const EdgeInsets.all(
          5.0,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: id == currentOptionId ? Colors.white : Colors.cyan,
            ),
          ),
        ),
      ),
    );
  }
}
