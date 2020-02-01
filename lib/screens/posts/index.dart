import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'post.dart';
import '../../providers/authProvider.dart';
import '../../providers/locationProvider.dart';
import '../../widgets/noContent.dart';
import '../../widgets/wait.dart';
import '../../widgets/topScreenFilterOption.dart';
import '../../languages/provincesTranslator.dart';
import '../../providers/postsProvider.dart';
import '../../util/filterList.dart';
import '../../languages/index.dart';

class Posts extends StatefulWidget {
  final searchBarString;
  final usersProvince;

  Posts({
    Key key,
    this.searchBarString,
    this.usersProvince,
  }) : super(key: key);
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> with AutomaticKeepAliveClientMixin {
  String currentFilterOption;
  int currentOptionId = 1;
  static int present = 0;
  int itemsPerPage = 10;
  List posts;
  DocumentSnapshot _lastPost;
  List currentPostsSnapshot = [];
  List renderedPosts = [];

  handleFilterOptionsChange(text, id) {
    setState(() {
      currentFilterOption = text;
      currentOptionId = id;
    });
  }

//  void initialLoadOfData() {
//    final initItems = Provider.of<PostsProvider>(context, listen: false)
//        .getInitialPosts('posts', itemsPerPage);
//    initItems.forEach((QuerySnapshot snapshot) {
//      List<Map<dynamic, dynamic>> newPosts = List();
//      newPosts = snapshot.documents.map((DocumentSnapshot docSnapshot) {
//        var post = {
//          'post': docSnapshot.data,
//          'postId': docSnapshot.documentID,
//        };
//        return post;
//      }).toList();
//
//      if (mounted) {
//        setState(() {
//          posts = newPosts;
//          _lastPost = snapshot.documents[snapshot.documents.length - 1];
//        });
//      }
//    });
//  }

  void loadMore(appLanguage, currentUserId) {
    bool request = false;
    if (!request) {
      final postsSnapshot = Provider.of<PostsProvider>(context)
          .getAllPosts('ids_posts', itemsPerPage, _lastPost);
      postsSnapshot.forEach((QuerySnapshot snapshot) {
        List<Map<String, dynamic>> newPosts = List();
        newPosts = snapshot.documents.map((DocumentSnapshot docSnapshot) {
          final post = {
            'id': docSnapshot.documentID,
            'location': docSnapshot.data['location'],
          };
          return post;
        }).toList();
        if (mounted) {
          setState(() {
            currentPostsSnapshot.addAll(newPosts);
            _lastPost = snapshot.documents[snapshot.documents.length - 1];
          });
        }
      });
    }
    request = true;
  }

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () {
      final postsSnapshot =
          Provider.of<PostsProvider>(context).getAllSnapshots('ids_posts');
      postsSnapshot.forEach((QuerySnapshot snapshot) {
        List<Map<String, dynamic>> newPosts = List();
        newPosts = snapshot.documents.map((DocumentSnapshot docSnapshot) {
          final post = {
            'id': docSnapshot.documentID,
            'location': docSnapshot.data['location'],
          };
          return post;
        }).toList();
        if (mounted) {
          setState(() {
            currentPostsSnapshot = newPosts;
            _lastPost = snapshot.documents[snapshot.documents.length - 1];
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final appLanguage = getLanguages(context);
    final currentUserId =
        Provider.of<AuthProvider>(context, listen: false).userId;
    final userLocality =
        Provider.of<LocationProvider>(context, listen: false).getUserLocality;
    if (currentFilterOption == null) {
      setState(() {
        currentFilterOption = userLocality;
      });
    }

    var _filteredPosts = filterListBasedOnLocation(
      posts: currentPostsSnapshot,
      currentFilterOption: currentFilterOption,
      currentUserId: currentUserId,
    );
    print(renderedPosts.length);

    return _buildContent(
      appLanguage: appLanguage,
      currentUserId: currentUserId,
      userLocation: userLocality,
      filteredPosts: _filteredPosts,
    );
  }

  Widget _buildContent({
    appLanguage,
    currentUserId,
    userLocation,
    filteredPosts,
  }) {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: <Widget>[
          filterOptions(appLanguage, userLocation),
          filteredPosts.length > 0
              ? Column(
                  children: <Widget>[
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filteredPosts.length,
                      itemBuilder: (context, index) {
                        final postId = filteredPosts[index]['id'];
//                        renderedPosts.add(Post(
//                          postId: postId,
//                          usersProvince: widget.usersProvince,
//                        ));

//                        return renderedPosts[index];
                        return Post(
                          postId: postId,
                          usersProvince: widget.usersProvince,
                        );
                      },
                    ),
                    FlatButton(
                      onPressed: () => loadMore(
                        appLanguage,
                        currentUserId,
                      ),
                      child: Text('load more'),
                    ),
                  ],
                )
              : noContent(appLanguage['noContent'], context)
//            },
//          ),
        ],
      ),
    );
  }

  Widget filterOptions(appLanguage, userLocation) {
    return SingleChildScrollView(
      child: Container(
        height: 40.0,
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 2.0),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            topScreenFilterOption(
              text: userLocation,
              id: 1,
              currentOptionId: currentOptionId,
              handleFilterOptionsChange: handleFilterOptionsChange,
            ),
            topScreenFilterOption(
              text: provincesTranslator[widget.usersProvince],
              id: 2,
              currentOptionId: currentOptionId,
              handleFilterOptionsChange: handleFilterOptionsChange,
            ),
            topScreenFilterOption(
              text: 'افغانستان',
              id: 3,
              currentOptionId: currentOptionId,
              handleFilterOptionsChange: handleFilterOptionsChange,
            ),
            topScreenFilterOption(
              text: appLanguage['myPosts'],
              id: 4,
              currentOptionId: currentOptionId,
              handleFilterOptionsChange: handleFilterOptionsChange,
            ),
            topScreenFilterOption(
              text: appLanguage['myFavorites'],
              id: 5,
              currentOptionId: currentOptionId,
              handleFilterOptionsChange: handleFilterOptionsChange,
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
