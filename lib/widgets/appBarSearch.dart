import 'package:flutter/material.dart';
import '../languages/index.dart';

class AppBarSearch extends StatefulWidget {
  final handleSearchBarStringChange;
  AppBarSearch(this.handleSearchBarStringChange);

  @override
  _AppBarSearchState createState() => _AppBarSearchState();
}

class _AppBarSearchState extends State<AppBarSearch> {
  String searchString = '';
  final searchBarController = TextEditingController();
  FocusNode searchFieldFocusNode = FocusNode();

  clearSearchTextField(context) {
    FocusScope.of(context).unfocus();
    setState(() {
      searchString = '';
    });
  }

  @override
  void dispose() {
    searchBarController.dispose();
    super.dispose();
  }

  handSearchStringChange(value) {
    setState(() {
      searchString = value;
    });
    widget.handleSearchBarStringChange(value);
  }

  @override
  void initState() {
    super.initState();
    searchBarController
        .addListener(() => handSearchStringChange(searchBarController.text));
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = getLanguages(context);

    return Container(
      height: 30.0,
      width: MediaQuery.of(context).size.width * 0.7,
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
//        onChanged: (value) {
//          widget.handleSearchBarStringChange(value);
//        },
        focusNode: searchFieldFocusNode,
        controller: searchBarController,
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
          suffixIcon: searchString.length == 0
              ? Icon(Icons.search, color: Colors.grey)
              : Container(
                  width: 20.0,
                  child: FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    child: Icon(Icons.clear),
                    onPressed: () {
                      Future.delayed(Duration(milliseconds: 50)).then((_) {
                        searchBarController.clear();
                        clearSearchTextField(context);
                      });
                    },
                  ),
                ),
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
