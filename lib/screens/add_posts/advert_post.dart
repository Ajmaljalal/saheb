import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import '../../widgets/button.dart';
//import '../../providers/languageProvider.dart';
import '../../languages/index.dart';
import '../../mixins/add_post.dart';

class AdvertPost extends StatefulWidget {
  @override
  _AdvertPostState createState() => _AdvertPostState();
}

class _AdvertPostState extends State<AdvertPost> with AddPostMixin {
  onSend() {}
  String dropdownValue = 'نوع معامله';
  final List<String> dropDownItems = [
    'نوع معامله',
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
    final appLanguage = getLanguages(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('${appLanguage['advert'].toString()}'),
              customButton(
                appLanguage: appLanguage,
                context: context,
                onClick: onSend,
                forText: 'send',
                width: MediaQuery.of(context).size.width * 0.2,
                height: 32.0,
              ),
            ],
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 15.0,
        ),
        height: MediaQuery.of(context).size.height * 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      typeOfBusinessOptions(
                        onDropDownChange: onDropDownChange,
                        dropdownValue: dropdownValue,
                        dropdownItems: dropDownItems,
                        context: context,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      postTitle(appLanguage['advert'], appLanguage),
                      SizedBox(
                        height: 10.0,
                      ),
                      textArea(appLanguage['advert'], appLanguage),
                      phoneNumberArea(appLanguage),
                      emailAddressArea(appLanguage),
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
