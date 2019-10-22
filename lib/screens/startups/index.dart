import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/languageProvider.dart';
import 'login_screen.dart';
import 'language_screen.dart';

class StartUps extends StatefulWidget {
  @override
  _StartUpsState createState() => _StartUpsState();
}

class _StartUpsState extends State<StartUps> {
//  bool languageSet = false;
//  setLanguage(context) async {
//    await Provider.of<LanguageProvider>(context).setLanguage();
//    print('language set');
//  }
//
//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//    if (!languageSet) {
//      setLanguage(context).then((result) {
//        setState(() {
//          languageSet = true;
//        });
//      });
//    }
//  }

  @override
  Widget build(BuildContext context) {
//    print(languageSet);
    String _language = Provider.of<LanguageProvider>(context).getLanguage;
    bool isLanguage =
        _language == 'pashto' || _language == 'dari' || _language == 'English';
    return isLanguage ? Login() : Language();
  }
}
