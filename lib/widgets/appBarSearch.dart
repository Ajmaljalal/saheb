import 'package:flutter/material.dart';
import '../languages/index.dart';

class AppBarSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appLanguage = getLanguages(context);
    return Container(
      height: 30.0,
      width: MediaQuery.of(context).size.width * 0.7,
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
          height: 0.95,
        ),
        decoration: InputDecoration(
          hintText: appLanguage['search'],
          hintStyle: TextStyle(
            fontSize: 15.0,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          suffixIcon: Icon(Icons.search, color: Colors.grey),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: Colors.white,
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
