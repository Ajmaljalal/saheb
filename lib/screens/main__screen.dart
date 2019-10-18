import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/languageProvider.dart';
import '../languages/index.dart';
import './market/index.dart';
import './posts/index.dart';
import './settings/index.dart';
import './add_posts/index.dart';
import '../widgets/searchBar.dart';
import '../screens/jobs/index.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentScreenIndex = 0;

  String _getAppBarTitle(language, context) {
    final appLanguage = getLanguages(context);
    if (language == 'English') {
      switch (_currentScreenIndex) {
        case 2:
          return 'Add new post';
        case 4:
          return 'Settings';
      }
    } else {
      switch (_currentScreenIndex) {
        case 2:
          return appLanguage['add new post'];
        case 3:
          return appLanguage['jobs'];
        case 4:
          return appLanguage['settings'];
      }
    }
    return '';
  }

  final List<Widget> screens = [
    Posts(),
    Market(),
    AddPost(),
    Jobs(),
    Settings(),
  ];

  void _setCurrentScreen(int index) {
    setState(() {
      _currentScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = Provider.of<LanguageProvider>(context).getLanguage;
    final renderSearchAndAdd =
        _currentScreenIndex == 0 || _currentScreenIndex == 1;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: renderSearchAndAdd,
        leading: Container(
          padding: EdgeInsets.only(right: 5.0),
          child: renderSearchAndAdd
              ? IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    size: 40.0,
                  ),
                  onPressed: () {
                    setState(() {
                      _currentScreenIndex = 2;
                    });
                  },
                )
              : null,
        ),
        title: renderSearchAndAdd
            ? SearchBar()
            : Text(
                _getAppBarTitle(language, context),
              ),
      ),
      body: screens[_currentScreenIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _setCurrentScreen,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentScreenIndex,
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 35.0,
            ),
            title: Text(
              '',
              style: TextStyle(fontSize: 0.0001),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.monetization_on,
              size: 35.0,
            ),
            title: Text(
              '',
              style: TextStyle(fontSize: 0.0001),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_outline,
              size: 40.0,
              color: Colors.white,
            ),
            title: Text(
              '',
              style: TextStyle(fontSize: 0.0001),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.work,
              size: 35.0,
            ),
            title: Text(
              '',
              style: TextStyle(fontSize: 0.0001),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              size: 35.0,
            ),
            title: Text(
              '',
              style: TextStyle(fontSize: 0.0001),
            ),
          ),
        ],
      ),
    );
  }
}
