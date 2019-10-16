import 'package:flutter/material.dart';

class General extends StatefulWidget {
  @override
  State createState() => _GeneralState();
}

class _GeneralState extends State<General> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('General'),
      ),
      body: Container(
        child: Text('General here'),
      ),
    );
  }
}
