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
  List filteredPosts;
  DocumentSnapshot _lastPost;

  handleFilterOptionsChange(text, id) {
    setState(() {
      currentFilterOption = text;
      currentOptionId = id;
    });
  }

  void initialLoadOfData() {
    final initItems = Provider.of<PostsProvider>(context, listen: false)
        .getInitialPosts('posts', itemsPerPage);
    initItems.forEach((QuerySnapshot snapshot) {
      List<Map<dynamic, dynamic>> newPosts = List();
      newPosts = snapshot.documents.map((DocumentSnapshot docSnapshot) {
        var post = {
          'post': docSnapshot.data,
          'postId': docSnapshot.documentID,
        };
        return post;
      }).toList();

      if (mounted) {
        setState(() {
          filteredPosts = newPosts;
          _lastPost = snapshot.documents[snapshot.documents.length - 1];
        });
      }
    });
  }

  void loadMore(appLanguage, currentUserId) {
    print('called again');
    bool request = false;
    if (!request) {
      final newItems = Provider.of<PostsProvider>(context, listen: false)
          .getAllPosts('posts', itemsPerPage, _lastPost);
      newItems.forEach((QuerySnapshot snapshot) {
        List<Map<dynamic, dynamic>> newPosts = List();
        newPosts = snapshot.documents.map((DocumentSnapshot docSnapshot) {
          var post = {
            'post': docSnapshot.data,
            'postId': docSnapshot.documentID,
          };
          return post;
        }).toList();

        if (mounted) {
          setState(() {
            filteredPosts.addAll(newPosts);
            _lastPost = snapshot.documents[snapshot.documents.length - 1];
          });
        }
        print(_lastPost.documentID);
      });
    }
    request = true;
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

    if (filteredPosts == null) {
      print('callled');
      initialLoadOfData();
      return Text('null');
    }

    var newFilteredPosts = filterList(
      posts: filteredPosts,
      currentFilterOption: currentFilterOption,
      currentUserId: currentUserId,
      type: 'posts',
      appLanguage: appLanguage,
      appBarSearchString: widget.searchBarString,
    );

    return _buildContent(
      appLanguage: appLanguage,
      currentUserId: currentUserId,
      userLocation: userLocality,
      posts: newFilteredPosts,
    );
  }

  Widget _buildContent({
    appLanguage,
    currentUserId,
    userLocation,
    posts,
  }) {
    print(filteredPosts[filteredPosts.length - 1]['postId']);

    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: <Widget>[
          filterOptions(appLanguage, userLocation),
          posts.length > 0
              ? Column(
                  children: <Widget>[
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final postId = posts.toList()[index]['postId'];
                        var post = posts.toList()[index]['post'];
                        return Post(
                          post: post,
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
