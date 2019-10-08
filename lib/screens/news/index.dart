import 'package:flutter/material.dart';

import 'social_card.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  List<Widget> numberOfCards = [
    SocialCard(),
    SocialCard(),
    SocialCard(),
    SocialCard(),
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return numberOfCards[index];
      },
      itemCount: numberOfCards.length,
    );
  }
}
