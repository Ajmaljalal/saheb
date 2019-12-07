import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:saheb/providers/authProvider.dart';
import 'package:saheb/providers/locationProvider.dart';
import 'package:saheb/widgets/noContent.dart';
import 'package:saheb/widgets/wait.dart';
import '../../widgets/topScreenFilterOption.dart';
import 'package:saheb/languages/provincesTranslator.dart';
import '../../providers/postsProvider.dart';
import '../../util/filterList.dart';
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

  @override
  Widget build(BuildContext context) {
    final appLanguage = getLanguages(context);
    final currentUserId = Provider.of<AuthProvider>(context).userId;
    final userLocality = Provider.of<LocationProvider>(context).getUserLocality;
    if (currentFilterOption == null) {
      setState(() {
        currentFilterOption = userLocality;
      });
    }
    return screenContent(appLanguage, currentUserId, userLocality);
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
                return wait(appLanguage['wait'], context);
              }
              if (snapshot.data.documents.toList().length == 0) {
                return noContent(appLanguage['noContent'], context);
              }
              List<DocumentSnapshot> tempList = snapshot.data.documents;
              List<Map<dynamic, dynamic>> posts = List();
              posts = tempList.map((DocumentSnapshot docSnapshot) {
                var post = {
                  'post': docSnapshot.data,
                  'postId': docSnapshot.documentID,
                };
                return post;
              }).toList();

              var filteredPosts = filterList(
                posts: posts,
                currentFilterOption: currentFilterOption,
                currentUserId: currentUserId,
                type: 'posts',
                appLanguage: appLanguage,
                appBarSearchString: widget.searchBarString,
              );

              return filteredPosts.length > 0
                  ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filteredPosts.length,
                      itemBuilder: (context, index) {
                        final postId = filteredPosts.toList()[index]['postId'];
                        var post = filteredPosts.toList()[index]['post'];
                        return Post(
                          post: post,
                          postId: postId,
                          usersProvince: widget.usersProvince,
                        );
                      },
                    )
                  : noContent(appLanguage['noContent'], context);
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
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 2.0),
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
}
