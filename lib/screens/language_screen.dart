import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store/store.dart';

class Language extends StatefulWidget {
  @override
  LanguageState createState() => LanguageState();
}

class LanguageState extends State<Language> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Container(
            color: Colors.deepPurple,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.4,
            ),
            child: Center(
              child: Column(
                children: <Widget>[
                  languageOption('pashto'),
                  languageOption('dari'),
                  languageOption('English'),
                ],
              ),
            ),
          ),
        ],
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
          Provider.of<Store>(context).changeLanguage(language);
          Navigator.pushNamed(context, '/login');
        },
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
            color: Colors.deepOrange,
            border: Border.all(
              color: Colors.deepOrange,
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
