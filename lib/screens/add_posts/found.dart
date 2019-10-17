import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/button.dart';
import '../../providers/languageProvider.dart';
import '../../languages/index.dart';

class Found extends StatefulWidget {
  @override
  State createState() => _FoundState();
}

class _FoundState extends State<Found> {
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
              Text('Found'),
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
        child: Text('Found here'),
      ),
    );
  }
}
