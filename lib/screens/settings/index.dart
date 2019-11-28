import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saheb/providers/locationProvider.dart';
import 'package:saheb/widgets/circularProgressIndicator.dart';
import '../../widgets/avatar.dart';
import '../../widgets/userNameHolder.dart';
import '../../widgets/userLocationHolder.dart';
import '../../widgets/button.dart';
import '../../providers/languageProvider.dart';
import '../../providers/authProvider.dart';
import '../../languages/index.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String appLanguageOption;

  onChangeAppLanguage(value) async {
    setState(() {
      appLanguageOption = value;
    });
    await Provider.of<LanguageProvider>(context).changeLanguage(value);
  }

  onSignOut() async {
    await Provider.of<AuthProvider>(context).logout();
  }

  Future getUserProfile() async {
    final user = await Provider.of<AuthProvider>(context).currentUser;
    return user;
  }

  @override
  Widget build(BuildContext context) {
//    final _language = Provider.of<LanguageProvider>(context).getLanguage;
    final appLanguage = getLanguages(context);
    final userLocation = Provider.of<LocationProvider>(context).getLocation;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 30.0,
          horizontal: 10.0,
        ),
        child: Column(
          children: <Widget>[
            _userProfile(
              getUserProfile,
              userLocation,
            ),
            Container(
              margin: EdgeInsets.only(top: 30.0),
              child: _settingsOptions(appLanguage),
            ),
            Divider(color: Colors.black),
            customButton(
              appLanguage: appLanguage,
              context: context,
              onClick: onSignOut,
              forText: 'signOut',
              width: MediaQuery.of(context).size.width * 0.5,
              height: 45.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _userProfile(currentUser, userLocation) {
    var user;
    return FutureBuilder(
      future: currentUser(),
      builder: (context, userSnapshot) {
        user = userSnapshot.data;
        if (user != null) {
          return Center(
            child: Column(
              children: <Widget>[
                imageRenderer(
                  height: 80.0,
                  width: 80.0,
                  photo: user.photoUrl,
                ),
                userNameHolder(name: user.displayName, fontSize: 30.0),
                userLocationHolder(userLocation),
              ],
            ),
          );
        } else
          return Center(child: progressIndicator());
      },
    );
  }

  Widget _settingsOptions(appLanguage) {
    return Center(
      child: _appLanguageOptions(appLanguage),
    );
  }

  Widget _appLanguageOptions(appLanguage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(color: Colors.black),
        Text(
          appLanguage['changeAppLanguage'],
          style: TextStyle(fontSize: 18.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: Row(
                children: <Widget>[
                  Radio(
                    value: 'pashto',
                    groupValue: appLanguageOption,
                    onChanged: onChangeAppLanguage,
                    activeColor: Theme.of(context).accentColor,
                  ),
                  Text('پښتو'),
                ],
              ),
            ),
            Flexible(
              child: Row(
                children: <Widget>[
                  Radio(
                    value: 'dari',
                    groupValue: appLanguageOption,
                    onChanged: onChangeAppLanguage,
                    activeColor: Theme.of(context).accentColor,
                  ),
                  Text('دری'),
                ],
              ),
            ),
            Flexible(
              child: Row(
                children: <Widget>[
                  Radio(
                    value: 'English',
                    groupValue: appLanguageOption,
                    onChanged: onChangeAppLanguage,
                    activeColor: Theme.of(context).accentColor,
                  ),
                  Text('English'),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
