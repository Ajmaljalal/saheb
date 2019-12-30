import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../locations/locations_sublocations.dart';
import '../locations/provincesList.dart';
import '../providers/authProvider.dart';
import '../providers/postsProvider.dart';
import '../widgets/progressIndicators.dart';
import '../widgets/locationPicker.dart';
import '../providers/locationProvider.dart';
import '../widgets/emptyBox.dart';
import '../languages/index.dart';
import './market/index.dart';
import './posts/index.dart';
import './settings/index.dart';
import './messages/index.dart';
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
  static String _currentProvince;
  static String _currentLocality;

  handleSearchBarStringChange(value) {
    setState(() {
      _searchBarString = value;
    });
  }

  onChangeUserProvince(value) {
    Provider.of<LocationProvider>(context).changeUserProvince(value);
    setState(() {
      _currentProvince = value;
    });
  }

  onChangeUserLocality(value) {
    Provider.of<LocationProvider>(context).changeUserLocality(value);
    setState(() {
      _currentLocality = value;
    });
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

  void _openAddPostScreens() {
    if (_currentScreenIndex == 0) {
      Navigator.pushNamed(context, '/addPost');
    }
    if (_currentScreenIndex == 1) {
      Navigator.pushNamed(context, '/addAdvertPost');
    }

    if (_currentScreenIndex == 2) {
      Navigator.pushNamed(context, '/addServicePost');
    }
  }

  @override
  Widget build(BuildContext context) {
    final renderSearchAndAdd = _currentScreenIndex == 0 ||
        _currentScreenIndex == 1 ||
        _currentScreenIndex == 2;
    final appLanguage = getLanguages(context);
    final currentLanguage = Provider.of<LanguageProvider>(context).getLanguage;
    final userLocality = Provider.of<LocationProvider>(context).getUserLocality;
    final userProvince = Provider.of<LocationProvider>(context).getUserProvince;
    final currentUserId = Provider.of<AuthProvider>(context).userId;
    final double fontSize = currentLanguage == 'English' ? 12.0 : 15.0;
    final List<Widget> screens = [
      Posts(
        searchBarString: _searchBarString,
        usersProvince: userProvince,
      ),
      Market(
        searchBarString: _searchBarString,
        usersProvince: userProvince,
      ),
      Services(),
      Settings(),
    ];
    return userLocality != null && userProvince != null
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
                  handleSearchBarStringChange: handleSearchBarStringChange,
                  appLanguage: appLanguage,
                  userId: currentUserId,
                ),
              ),
            ),
            body: screens[_currentScreenIndex],
            floatingActionButton:
                _currentScreenIndex != 3 ? actionButton() : emptyBox(),
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
                    icon: AntDesign.aliwangwang,
                    fontSize: fontSize,
                  ),
                  bottomNavBarItem(
                    text: appLanguage['market'],
                    icon: FontAwesome.dollar,
                    fontSize: fontSize,
                  ),
                  bottomNavBarItem(
                    text: appLanguage['services'],
                    icon: FontAwesome.briefcase,
                    fontSize: fontSize,
                  ),
                  bottomNavBarItem(
                    text: appLanguage['profile'],
                    icon: Octicons.person,
                    fontSize: fontSize,
                  ),
                ],
              ),
            ),
          )
        : locationPicker(provincesList);
  }

  FloatingActionButton actionButton() {
    return FloatingActionButton(
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
      onPressed: () {
        _openAddPostScreens();
      },
      mini: true,
    );
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

  renderMessagesIconAndCount(appLanguage, userId) {
    return Container(
      child: StreamBuilder(
        stream:
            Provider.of<PostsProvider>(context).getAllMessages(userId: userId),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return emptyMessageIcon();
          }
          if (snapshot.data.documents.toList().length == 0) {
            return emptyMessageIcon();
          }
          List<DocumentSnapshot> tempList = snapshot.data.documents;
          List messages = List();
          messages = tempList;

          var filteredMessages = messages;
          return messageIconWithCount(filteredMessages, userId);
        },
      ),
    );
  }

  Widget emptyMessageIcon() {
    return Container(
      padding: EdgeInsets.only(
        right: 8.0,
        left: 8.0,
      ),
      child: InkWell(
        child: Icon(
          Icons.email,
          size: 30.0,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Messages(
                messages: null,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget messageIconWithCount(messages, userId) {
    List filteredMessages = messages.map((DocumentSnapshot messagesSnapshot) {
      var message = {
        'conversations': messagesSnapshot.data['messages'],
        'messageId': messagesSnapshot.documentID,
        'about': messagesSnapshot.data['about'],
        'initiator': messagesSnapshot.data['initiator'],
      };
      return message;
    }).toList();

    List unSeenMessages;
    for (var i = 0; i < filteredMessages.length; i++) {
      var newMessages = (filteredMessages[i]['conversations']);
      unSeenMessages = newMessages
          .where((message) =>
              message['ownerId'] != userId && message['seen'] == false)
          .toList();
    }

    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            right: 8.0,
            left: 8.0,
          ),
          child: InkWell(
            child: Icon(
              Icons.email,
              size: 30.0,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Messages(
                    messages: filteredMessages,
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 15.0,
          right: 0,
          left: 25,
          child: unSeenMessages.length > 0
              ? Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      unSeenMessages.length.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : emptyBox(),
        ),
      ],
    );
  }

  Widget appBarTitle({
    renderSearchAndAdd,
    currentLanguage,
    handleSearchBarStringChange,
    appLanguage,
    userId,
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
              ? renderMessagesIconAndCount(appLanguage, userId)
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
                        _openAddPostScreens();
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
                        _openAddPostScreens();
                      },
                    ),
                  ),
                )
              : emptyBox(),
          renderSearchAndAdd
              ? AppBarSearch(handleSearchBarStringChange)
              : emptyBox(),
          renderSearchAndAdd
              ? renderMessagesIconAndCount(appLanguage, userId)
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

  Widget locationPicker(provinces) {
    final appLanguage = getLanguages(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.location_on,
              size: 50.0,
              color: Colors.cyan,
            ),
            Center(
              child: Text(
                appLanguage['chooseYourLocation'],
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            FutureBuilder(
              future: Provider.of<LocationProvider>(context).setLocation(),
              builder: (ctx, locationResultSnapshot) =>
                  locationResultSnapshot.connectionState ==
                          ConnectionState.waiting
                      ? Center(
                          child: circularProgressIndicator(),
                        )
                      : Column(
                          children: <Widget>[
                            Container(
                              child: DropDownPicker(
                                onChange: onChangeUserProvince,
                                value: _currentProvince != null
                                    ? _currentProvince
                                    : appLanguage['province'],
                                items: provinces,
                                hintText: appLanguage['search'],
                                label: appLanguage['province'],
                                search: true,
                              ),
                            ),
                            _currentProvince != null
                                ? Container(
                                    child: DropDownPicker(
                                      onChange: onChangeUserLocality,
                                      value: _currentLocality != null
                                          ? _currentLocality
                                          : appLanguage['locality'],
                                      items: locations[_currentProvince],
                                      hintText: appLanguage['search'],
                                      label: appLanguage['locality'],
                                      search: true,
                                    ),
                                  )
                                : emptyBox(),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
