import 'package:flutter/material.dart';
//import 'package:bmnav/bmnav.dart' as bmnav;
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import '../languages/index.dart';
import './market/index.dart';
import './posts/index.dart';
import './settings/index.dart';
import '../widgets/appBarSearch.dart';
import '../screens/services/index.dart';
//import '../languages/index.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static int _currentScreenIndex = 0;
//  var _location;

  String _getAppBarTitle(context) {
    final appLanguage = getLanguages(context);
    switch (_currentScreenIndex) {
      case 4:
        return appLanguage['settings'];
      default:
        return '';
    }
  }

  final List<Widget> screens = [
    Posts(),
    Market(),
    Services(),
    Settings(),
  ];
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
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      margin: EdgeInsets.only(
                        left: 5.0,
                        right: 5.0,
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
                        right: 5.0,
                        left: 5.0,
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
              title: Text(appLanguage['home']),
              activeColor: Colors.cyan,
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.monetization_on),
                title: Text(appLanguage['market']),
                activeColor: Colors.cyan),
            BottomNavyBarItem(
                icon: Icon(Icons.work),
                title: Text(appLanguage['services']),
                activeColor: Colors.cyan),
            BottomNavyBarItem(
                icon: Icon(Icons.person),
                title: Text(
                  appLanguage['me'],
                ),
                activeColor: Colors.cyan),
          ],
        ),
      ),
    );
  }
}
