import 'package:flutter/material.dart';

class AdvertPost extends StatefulWidget {
  @override
  _AdvertPostState createState() => _AdvertPostState();
}

class _AdvertPostState extends State<AdvertPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('advert'),
      ),
      body: Container(
        child: Text('advert here'),
      ),
    );
  }
}
