import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/avatar.dart';
import '../../widgets/userNameHolder.dart';
import '../../widgets/userLocationHolder.dart';
import '../../widgets/button.dart';
import '../../providers/languageProvider.dart';
import '../../languages/index.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String appLanguage = 'pashto';

  onChangeAppLanguage(value) {
    setState(() {
      appLanguage = value;
    });
  }

  onSignOut() {
    print('signed out');
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
              child: _settingsOptions(),
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

  Widget _settingsOptions() {
    return Center(
      child: _appLanguageOptions(),
    );
  }

  Widget _appLanguageOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(color: Colors.black),
        Text(
          'د آپلیکشن ژبه واړوئ!',
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
                    fontSize: 16.0,
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
