import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/postsProvider.dart';
import '../../languages/index.dart';
import 'advert.dart';

class Market extends StatefulWidget {
  @override
  _MarketState createState() => _MarketState();
}

class _MarketState extends State<Market> {
  @override
  Widget build(BuildContext context) {
    final appLanguage = getLanguages(context);
    return StreamBuilder(
      stream: Provider.of<PostsProvider>(context).getAllPosts('adverts'),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: Text(appLanguage['wait']));
        }
        if (snapshot.data.documents.toList().length == 0) {
          return Center(
            child: Text(appLanguage['noContent']),
          );
        }
        return ListView.builder(
          itemBuilder: (context, index) {
            var advert = snapshot.data.documents[index];
            return Advert(advert: advert);
          },
          itemCount: snapshot.data.documents.length,
        );
      },
    );
    ;
  }
}
