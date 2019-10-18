import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.0,
      width: MediaQuery.of(context).size.width * 1,
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
          height: 0.95,
        ),
        decoration: InputDecoration(
          hintText: 'جستجو...',
          hintStyle: TextStyle(
            fontSize: 15.0,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          suffixIcon: Icon(Icons.search, color: Colors.grey),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
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
