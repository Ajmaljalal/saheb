import 'package:flutter/material.dart';

class Urgent extends StatefulWidget {
  @override
  State createState() => _UrgentState();
}

class _UrgentState extends State<Urgent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('urgent'),
      ),
      body: Container(
        child: Text('urgent here'),
      ),
    );
  }
}
