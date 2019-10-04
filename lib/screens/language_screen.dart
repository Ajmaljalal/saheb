import 'package:flutter/material.dart';

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
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://media-cdn.tripadvisor.com/media/photo-s/15/97/85/49/very-good-place-for-the.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black],
                begin: AlignmentDirectional.topCenter,
                end: AlignmentDirectional.bottomCenter,
              ),
            ),
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
          )
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
          print(_lang);
        },
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.deepPurple,
              width: 3.0,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(
              _lang,
              style: TextStyle(
                color: Colors.white,
                fontSize: _lang == 'English' ? 22 : 27,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
