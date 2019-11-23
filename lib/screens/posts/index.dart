import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  String currentFilterOption = 'احمد شاه بابا مینه';
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
    return screenContent(appLanguage);
  }

  Widget screenContent(appLanguage) {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: <Widget>[
          filterOptions(),
          StreamBuilder(
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
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var post = snapshot.data.documents[index];
                  return Post(post: post);
                },
                itemCount: snapshot.data.documents.length,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget filterOptions() {
    return SingleChildScrollView(
      child: Container(
//        color: Colors.blueAccent,
//        padding: EdgeInsets.all(
//          5.0,
//        ),
        height: 40.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            filterOption('احمد شاه بابا مینه', 1),
            filterOption('کابل', 2),
            filterOption('افغانستان', 3),
            filterOption('زما لیکنې', 4),
            filterOption('نشاني شوي', 5),
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
            new BoxShadow(
              color: Colors.grey[400],
              blurRadius: 5.0,
            )
          ],
        ),
        constraints: BoxConstraints(
          minWidth: 50.0,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        margin: EdgeInsets.all(
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
