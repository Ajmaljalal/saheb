import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:provider/provider.dart';
import 'package:saheb/locations/locations_sublocations.dart';
import 'package:saheb/widgets/circularProgressIndicator.dart';
import 'package:saheb/widgets/locationPicker.dart';
import '../providers/locationProvider.dart';
import '../widgets/emptyBox.dart';
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
  static String _userProvince;

  handleSearchBarStringChange(value) {
    setState(() {
      _searchBarString = value;
    });
  }

  onChangeLocation(value) async {
    await Provider.of<LocationProvider>(context).changeLocation(value);
  }

  String _getAppBarTitle(context) {
    final appLanguage = getLanguages(context);
    switch (_currentScreenIndex) {
      case 3:
        return appLanguage['settings'];
      default:
        return '';
    }
  }

  void _setCurrentScreen(int index) async {
    setState(() {
      _currentScreenIndex = index;
    });
  }

  @override
  didChangeDependencies() {
    Provider.of<LocationProvider>(context).getProvince().then((province) {
      if (this.mounted) {
        setState(() {
          _userProvince = province;
        });
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final renderSearchAndAdd = _currentScreenIndex == 0 ||
        _currentScreenIndex == 1 ||
        _currentScreenIndex == 2;
    final appLanguage = getLanguages(context);
    final currentLanguage = Provider.of<LanguageProvider>(context).getLanguage;
    final userLocation = Provider.of<LocationProvider>(context).getLocation;
    final double fontSize = currentLanguage == 'English' ? 12.0 : 15.0;
    if (userLocation == null) {}
    final List<Widget> screens = [
      Posts(
        searchBarString: _searchBarString,
        usersProvince: _userProvince,
      ),
      Market(
        searchBarString: _searchBarString,
        usersProvince: _userProvince,
      ),
      Services(),
      Settings(),
    ];
    return userLocation != null
        ? Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(45.0),
              child: AppBar(
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
                showElevation: true,
                onItemSelected: _setCurrentScreen,
                items: [
                  bottomNavBarItem(
                    text: appLanguage['home'],
                    icon: Icons.home,
                    fontSize: fontSize,
                  ),
                  bottomNavBarItem(
                    text: appLanguage['market'],
                    icon: Icons.monetization_on,
                    fontSize: fontSize,
                  ),
                  bottomNavBarItem(
                    text: appLanguage['services'],
                    icon: Icons.work,
                    fontSize: fontSize,
                  ),
                  bottomNavBarItem(
                    text: appLanguage['settings'],
                    icon: Icons.settings,
                    fontSize: fontSize,
                  ),
                ],
              ),
            ),
          )
        : locationPicker();
  }

  BottomNavyBarItem bottomNavBarItem({
    text,
    icon,
    fontSize,
  }) {
    return BottomNavyBarItem(
      icon: Icon(icon),
      title: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
        ),
      ),
      activeColor: Colors.cyan,
    );
  }

  Widget appBarTitle({
    renderSearchAndAdd,
    currentLanguage,
    handleSearchBarStringChange,
  }) {
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

  Widget locationPicker() {
    final appLanguage = getLanguages(context);
    return Scaffold(
      body: SafeArea(
        child: _userProvince != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      appLanguage['chooseYourLocation'],
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future:
                        Provider.of<LocationProvider>(context).setLocation(),
                    builder: (ctx, languageResultSnapshot) =>
                        languageResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? Center(
                                child: progressIndicator(),
                              )
                            : Container(
                                child: DropDownPicker(
                                  onChange: onChangeLocation,
                                  value: appLanguage['location'],
                                  items: locations[_userProvince],
                                  hintText: appLanguage['location'],
                                  label: appLanguage['location'],
                                  search: true,
                                ),
                              ),
                  ),
                ],
              )
            : Center(
                child: progressIndicator(),
              ),
      ),
    );
  }
}
