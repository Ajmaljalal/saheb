import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/button.dart';
import '../../providers/languageProvider.dart';
import '../../languages/index.dart';
import '../../mixins/add_post.dart';

class AdvertPost extends StatefulWidget {
  @override
  _AdvertPostState createState() => _AdvertPostState();
}

class _AdvertPostState extends State<AdvertPost> with AddPostMixin {
  onSend() {}
  String dropdownValue = 'Sell';
  final List<String> dropDownItems = [
    'Sell',
    'Rent',
    'Buy',
    'Need for a professional'
  ];

  onDropDownChange(value) {
    setState(() {
      dropdownValue = value;
    });
  }

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
              Text(
                'Advert',
              ),
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
        margin: EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 15.0,
        ),
        height: MediaQuery.of(context).size.height * 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Container(
                child: Column(
                  children: <Widget>[
                    typeOfBusinessOptions(
                      onDropDownChange: onDropDownChange,
                      dropdownValue: dropdownValue,
                      dropdownItems: dropDownItems,
                    ),
                    postTitle(),
                    textArea(),
                    Row(
                      children: <Widget>[
                        photoVideoArea(
                          'https://www.bestfunforall.com/better/imgs/Landscapes%20Nature%20For%20Mobile%20wallpaper%20%204.jpg',
                        ),
                        photoVideoArea(
                          'https://www.bestfunforall.com/better/imgs/Landscapes%20Nature%20For%20Mobile%20wallpaper%20%204.jpg',
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              child: bottomBar(
                onSend: onSend,
                onOpenPhotoVideo: onSend,
                context: context,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
