import 'package:flutter/material.dart';

class Found extends StatefulWidget {
  @override
  State createState() => _FoundState();
}

class _FoundState extends State<Found> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Found'),
      ),
      body: Container(
        child: Text('Found here'),
      ),
    );
  }
}
