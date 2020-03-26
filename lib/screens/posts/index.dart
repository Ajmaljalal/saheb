import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.pywast.pywast/widgets/emptySpace.dart';
import 'package:com.pywast.pywast/widgets/progressIndicators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'post.dart';
import '../../providers/authProvider.dart';
import '../../providers/locationProvider.dart';
import '../../widgets/noContent.dart';
//import '../../widgets/wait.dart';
import '../../widgets/topScreenFilterOption.dart';
import '../../languages/provincesTranslator.dart';
import '../../providers/postsProvider.dart';
import '../../providers/postsStore.dart';
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
  int itemsPerPage = 10;
  List posts;
  List currentPostsSnapshot = [];
  String currentUserId;
  var appLanguage;
  var userLocality;
  bool moreDataLoading = false;
  String postsLocation;

  handleFilterOptionsChange(text, id) {
    setState(() {
      currentFilterOption = text;
      currentOptionId = id;
      postsLocation = setPostsLocation(text);
    });
  }

  void loadMorePost(appLanguage, currentUserId) {
    setState(() {
      moreDataLoading = true;
    });
    if (moreDataLoading) {
      final _lastPost = getLastPost();
      final postsSnapshot = Provider.of<PostsProvider>(context).getMorePosts(
        'ids_posts',
        itemsPerPage,
        _lastPost,
        currentFilterOption,
      );
      postsSnapshot.forEach((QuerySnapshot snapshot) {
        List<Post> newPosts = List();
        newPosts = snapshot.documents.map((DocumentSnapshot docSnapshot) {
          return Post(
            postId: docSnapshot.documentID,
            usersProvince: widget.usersProvince,
          );
        }).toList();
        if (mounted) {
          Provider.of<PostsStore>(context)
              .addPostToStore(newPosts, postsLocation);
          setLastPost(snapshot);
          setState(() {
            moreDataLoading = false;
          });
        }
      });
    }
  }

  DocumentSnapshot getLastPost() {
    DocumentSnapshot lastPost;
    if (postsLocation == 'local') {
      lastPost = Provider.of<PostsStore>(context).getLastLocalPost;
    }
    if (postsLocation == 'province') {
      lastPost = Provider.of<PostsStore>(context).getLastLocalPost;
    }
    if (postsLocation == 'country') {
      lastPost = Provider.of<PostsStore>(context).getLastLocalPost;
    }
    return lastPost;
  }

  void setLastPost(QuerySnapshot snapshot) {
    if (postsLocation == 'local') {
      Provider.of<PostsStore>(context)
          .setLastLocalPost(snapshot.documents[snapshot.documents.length - 1]);
    }
    if (postsLocation == 'province') {
      Provider.of<PostsStore>(context).setLastProvincePost(
          snapshot.documents[snapshot.documents.length - 1]);
    }
    if (postsLocation == 'country') {
      Provider.of<PostsStore>(context).setLastCountryPost(
          snapshot.documents[snapshot.documents.length - 1]);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        setState(() {
          postsLocation = setPostsLocation(currentFilterOption);
        });
        List posts = getAllPosts();
        print(posts.length);
        if (posts.length == 0) {
          setInitialPosts();
        }
      },
    );
  }

  String setPostsLocation(_currentFilterOption) {
    String location;
    if (_currentFilterOption.contains(userLocality)) {
      location = 'local';
    } else if (_currentFilterOption.contains('افغانستان')) {
      location = 'country';
    } else {
      location = 'province';
    }
    return location;
  }

  List getAllPosts() {
    List posts;
    if (postsLocation == 'local') {
      posts = Provider.of<PostsStore>(context).getLocalPosts;
    } else if (postsLocation == 'country') {
      posts = Provider.of<PostsStore>(context).getCountryPosts;
    } else {
      posts = Provider.of<PostsStore>(context).getProvincePosts;
    }
    return posts;
  }

  void setInitialPosts() {
    final postsSnapshot = Provider.of<PostsProvider>(context)
        .getAllSnapshots('ids_posts', currentFilterOption);
    postsSnapshot.forEach(
      (QuerySnapshot snapshot) {
        List<Post> newPosts = List();
        newPosts = snapshot.documents.map((DocumentSnapshot docSnapshot) {
          return Post(
            postId: docSnapshot.documentID,
            usersProvince: widget.usersProvince,
          );
        }).toList();
        if (snapshot.documents.length != 0) {
          Provider.of<PostsStore>(context)
              .addPostToStore(newPosts, postsLocation);
          setLastPost(snapshot);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (currentFilterOption == null &&
        currentUserId == null &&
        userLocality == null) {
      setState(() {
        userLocality = Provider.of<LocationProvider>(context, listen: false)
            .getUserLocality;
        appLanguage = getLanguages(context);
        currentUserId =
            Provider.of<AuthProvider>(context, listen: false).userId;
        currentFilterOption = userLocality;
      });
    }

    return _buildContent(
      appLanguage: appLanguage,
      currentUserId: currentUserId,
      userLocation: userLocality,
    );
  }

  Widget _buildContent({
    appLanguage,
    currentUserId,
    userLocation,
  }) {
    final posts = getAllPosts();
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: <Widget>[
          filterOptions(appLanguage, userLocation),
          Column(
            children: <Widget>[
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return posts[index];
                },
              ),
              loadMoreButton(appLanguage, currentUserId),
            ],
          )
        ],
      ),
    );
  }

  Container loadMoreButton(appLanguage, currentUserId) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      width: 150.0,
      child: !moreDataLoading
          ? RaisedButton(
              color: Colors.white,
              textColor: Colors.purple,
              onPressed: () => loadMorePost(
                appLanguage,
                currentUserId,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    appLanguage['loadMore'],
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  EmptySpace(
                    width: 5.0,
                  ),
                  Icon(Icons.more_horiz),
                ],
              ),
            )
          : circularProgressIndicator(),
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
  bool get wantKeepAlive => true;
}
