import 'package:flutter/material.dart';
import '../languages/index.dart';
import './market/index.dart';
import './posts/index.dart';
import './settings/index.dart';
import './add_posts/index.dart';
import '../widgets/appBarSearch.dart';
import '../screens/jobs/index.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentScreenIndex = 0;

  String _getAppBarTitle(context) {
    final appLanguage = getLanguages(context);
    switch (_currentScreenIndex) {
      case 2:
        return appLanguage['addNewPost'];
      case 4:
        return appLanguage['settings'];
      default:
        return '';
    }
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
    final renderSearchAndAdd = _currentScreenIndex == 0 ||
        _currentScreenIndex == 1 ||
        _currentScreenIndex == 3;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: AppBar(
//        centerTitle: true,
          titleSpacing: 0.0,
          automaticallyImplyLeading: renderSearchAndAdd,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              renderSearchAndAdd
                  ? Container(
                      height: 30.0,
                      width: 30.0,
                      decoration: BoxDecoration(
//                      color: Colors.cyan,
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      margin: EdgeInsets.only(
                        left: 15.0,
                      ),
                      child: Center(
                        child: InkWell(
                          child: Icon(
                            Icons.add,
                            size: 25.0,
                          ),
                          onTap: () {
                            setState(() {
                              _currentScreenIndex = 2;
                            });
                          },
                        ),
                      ),
                    )
                  : SizedBox(
                      width: 0.0,
                    ),
              renderSearchAndAdd
                  ? AppBarSearch()
                  : SizedBox(
                      width: 0.0,
                    ),
              renderSearchAndAdd
                  ? Container(
                      padding: EdgeInsets.only(
                        right: 15.0,
                      ),
                      child: InkWell(
                        child: Icon(
                          Icons.message,
                          size: 30.0,
                        ),
                        onTap: () {},
                      ),
                    )
                  : SizedBox(width: 0.0),
              renderSearchAndAdd
                  ? SizedBox(
                      width: 0.0,
                    )
                  : Text(
                      _getAppBarTitle(context).toString(),
                    ),
            ],
          ),
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
