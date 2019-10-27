import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  String appLanguage;

  @override
  didChangeDependencies() {
    appLanguage = Provider.of<LanguageProvider>(context).getLanguage;
    super.didChangeDependencies();
  }

  onChangeAppLanguage(value) async {
    setState(() {
      appLanguage = value;
    });
    await Provider.of<LanguageProvider>(context).changeLanguage(value);
  }

  onSignOut() async {
    await Provider.of<AuthProvider>(context).logout();
//    bool _isAuth = Provider.of<AuthProvider>(context).isAuth;
//    if (_isAuth == false) {
//      Navigator.pushReplacementNamed(context, '/login');
//    }
  }

  @override
  Widget build(BuildContext context) {
    final _language = Provider.of<LanguageProvider>(context).getLanguage;
    final appLanguage = getLanguages(context);
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 30.0,
          horizontal: 10.0,
        ),
        child: Column(
          children: <Widget>[
            _userProfile(),
            Container(
              margin: EdgeInsets.only(top: 30.0),
              child: _settingsOptions(appLanguage),
            ),
            Divider(color: Colors.black),
            customButton(
              userLanguage: _language,
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

  Widget _userProfile() {
    return Center(
      child: Column(
        children: <Widget>[
          imageRenderer(
            height: 80.0,
            width: 80.0,
          ),
          userNameHolder(name: 'Ajmal Jalal', fontSize: 30.0),
          userLocationHolder('12 District'),
        ],
      ),
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
              child: RadioListTile(
                title: Text(
                  'پښتو',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                value: 'pashto',
                groupValue: appLanguage,
                onChanged: onChangeAppLanguage,
                activeColor: Theme.of(context).accentColor,
              ),
            ),
            Flexible(
              child: RadioListTile(
                title: Text(
                  'دری',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                value: 'dari',
                groupValue: appLanguage,
                onChanged: onChangeAppLanguage,
                activeColor: Theme.of(context).accentColor,
              ),
            ),
            Flexible(
              child: RadioListTile(
                title: Text(
                  'English',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                value: 'English',
                groupValue: appLanguage,
                onChanged: onChangeAppLanguage,
                activeColor: Theme.of(context).accentColor,
              ),
            ),
          ],
        )
      ],
    );
  }
}
