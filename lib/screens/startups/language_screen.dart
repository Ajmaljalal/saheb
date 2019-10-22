import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/languageProvider.dart';

class Language extends StatefulWidget {
  @override
  LanguageState createState() => LanguageState();
}

class LanguageState extends State<Language> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).accentColor,
                    Theme.of(context).primaryColor,
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.3,
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      languageOption('pashto'),
                      languageOption('dari'),
                      languageOption('English'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget languageOption(String language) {
    String _lang = language;
    if (language == 'pashto') {
      _lang = 'پښتو';
    }
    if (language == 'dari') {
      _lang = 'دری';
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: GestureDetector(
        onTap: () {
          Provider.of<LanguageProvider>(context).changeLanguage(language);
          Navigator.pushReplacementNamed(context, '/login');
        },
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            border: Border.all(
              color: Colors.white,
              width: 3.0,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(
              _lang,
              style: TextStyle(
                color: Colors.white,
                fontSize: _lang == 'English' ? 25 : 30,
                fontFamily: 'BadrLight',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
