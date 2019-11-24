import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:provider/provider.dart';
import 'package:saheb/widgets/emptyBox.dart';
import '../languages/index.dart';
import './market/index.dart';
import './posts/index.dart';
import './settings/index.dart';
import '../widgets/appBarSearch.dart';
import '../screens/services/index.dart';
import '../providers/languageProvider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static int _currentScreenIndex = 0;
  static String _searchBarString;
//  var _location;

  handleSearchBarStringChange(value) {
    setState(() {
      _searchBarString = value;
    });
  }

  String _getAppBarTitle(context) {
    final appLanguage = getLanguages(context);
    switch (_currentScreenIndex) {
      case 3:
        return appLanguage['me'];
      default:
        return '';
    }
  }

  void _setCurrentScreen(int index) async {
//    List<Placemark> placemark =
////        await Geolocator().placemarkFromCoordinates(34.519822, 69.328775);
    setState(() {
      _currentScreenIndex = index;
//      _location = placemark[0].subLocality;
    });
  }

  @override
  Widget build(BuildContext context) {
    final renderSearchAndAdd = _currentScreenIndex == 0 ||
        _currentScreenIndex == 1 ||
        _currentScreenIndex == 2;
    final appLanguage = getLanguages(context);
    final currentLanguage = Provider.of<LanguageProvider>(context).getLanguage;
    double fontSize = currentLanguage == 'English' ? 12.0 : 15.0;
    final List<Widget> screens = [
      Posts(searchBarString: _searchBarString),
      Market(),
      Services(),
      Settings(),
    ];
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: AppBar(
//        centerTitle: true,
          titleSpacing: 0.0,
          automaticallyImplyLeading: renderSearchAndAdd,
          title: appBarTitle(
              renderSearchAndAdd: renderSearchAndAdd,
              currentLanguage: currentLanguage,
              handleSearchBarStringChange: handleSearchBarStringChange),
        ),
      ),
      body: screens[_currentScreenIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.cyanAccent,
              width: .3,
            ),
          ),
        ),
        child: BottomNavyBar(
          selectedIndex: _currentScreenIndex,
          showElevation: true, // use this to remove appBar's elevation
          onItemSelected: _setCurrentScreen,
          items: [
            BottomNavyBarItem(
              icon: Icon(Icons.home),
              title: Text(
                appLanguage['home'],
                style: TextStyle(
                  fontSize: fontSize,
                ),
              ),
              activeColor: Colors.cyan,
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.monetization_on),
                title: Text(
                  appLanguage['market'],
                  style: TextStyle(
                    fontSize: fontSize,
                  ),
                ),
                activeColor: Colors.cyan),
            BottomNavyBarItem(
                icon: Icon(
                  Icons.work,
                  size: 22.0,
                ),
                title: Text(
                  appLanguage['services'],
                  style: TextStyle(
                    fontSize: fontSize,
                  ),
                ),
                activeColor: Colors.cyan),
            BottomNavyBarItem(
                icon: Icon(Icons.person),
                title: Text(
                  appLanguage['me'],
                  style: TextStyle(
                    fontSize: fontSize,
                  ),
                ),
                activeColor: Colors.cyan),
          ],
        ),
      ),
    );
  }

  Widget appBarTitle(
      {renderSearchAndAdd, currentLanguage, handleSearchBarStringChange}) {
    if (currentLanguage == 'English') {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          renderSearchAndAdd
              ? emptyBox()
              : Text(
                  _getAppBarTitle(context).toString(),
                ),
          renderSearchAndAdd
              ? Container(
                  padding: EdgeInsets.only(
                    right: 8.0,
                    left: 8.0,
                  ),
                  child: InkWell(
                    child: Icon(
                      Icons.message,
                      size: 30.0,
                    ),
                    onTap: () {},
                  ),
                )
              : emptyBox(),
          renderSearchAndAdd
              ? AppBarSearch(handleSearchBarStringChange)
              : emptyBox(),
          renderSearchAndAdd
              ? Container(
                  height: 30.0,
                  width: 30.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  margin: EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                  ),
                  child: Center(
                    child: InkWell(
                      child: Icon(
                        Icons.add,
                        size: 25.0,
                      ),
                      onTap: () {
                        setState(() {
                          Navigator.pushNamed(context, '/addPost');
                        });
                      },
                    ),
                  ),
                )
              : emptyBox(),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          renderSearchAndAdd
              ? Container(
                  height: 30.0,
                  width: 30.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  margin: EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                  ),
                  child: Center(
                    child: InkWell(
                      child: Icon(
                        Icons.add,
                        size: 25.0,
                      ),
                      onTap: () {
                        setState(() {
                          Navigator.pushNamed(context, '/addPost');
                        });
                      },
                    ),
                  ),
                )
              : emptyBox(),
          renderSearchAndAdd
              ? AppBarSearch(handleSearchBarStringChange)
              : emptyBox(),
          renderSearchAndAdd
              ? Container(
                  padding: EdgeInsets.only(
                    right: 8.0,
                    left: 8.0,
                  ),
                  child: InkWell(
                    child: Icon(
                      Icons.message,
                      size: 30.0,
                    ),
                    onTap: () {},
                  ),
                )
              : emptyBox(),
          renderSearchAndAdd
              ? emptyBox()
              : Text(
                  _getAppBarTitle(context).toString(),
                ),
        ],
      );
    }
  }
}
