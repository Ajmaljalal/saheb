import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/button.dart';
import '../../providers/languageProvider.dart';
import '../../languages/index.dart';

class Urgent extends StatefulWidget {
  @override
  State createState() => _UrgentState();
}

class _UrgentState extends State<Urgent> {
  onSend() {}
  @override
  Widget build(BuildContext context) {
    final _language = Provider.of<LanguageProvider>(context).getLanguage;
    final appLanguage = getLanguages(context);
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Urgent'),
              customButton(
                userLanguage: _language,
                appLanguage: appLanguage,
                context: context,
                onClick: onSend,
                forText: 'send',
                width: MediaQuery.of(context).size.width * 0.2,
                height: 28.0,
              ),
            ],
          ),
        ),
      ),
      body: Container(
        child: Text('urgent here'),
      ),
    );
  }
}
