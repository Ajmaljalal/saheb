import 'package:flutter/material.dart';

class Lost extends StatefulWidget {
  @override
  State createState() => _LostState();
}

class _LostState extends State<Lost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lost'),
      ),
      body: Container(
        child: Text('Lost here'),
      ),
    );
  }
}
