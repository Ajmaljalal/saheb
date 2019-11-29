import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saheb/providers/locationProvider.dart';
import 'advert_post.dart';
import 'none_advert_post.dart';
import '../../languages/index.dart';
import '../../providers/languageProvider.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  String postType = '';
  var changeCurrentIndexFunction;
  onSelectPostType(value) {
    setState(() {
      postType = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = getLanguages(context);
    final currentLanguage = Provider.of<LanguageProvider>(context).getLanguage;
    final usersProvince =
        Provider.of<LocationProvider>(context).getUserProvince;
    double fontSize = currentLanguage == 'English' ? 13.0 : 15.0;
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text(appLanguage['addNewPost'].toString()),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            topLeft: Radius.circular(20.0),
          ),
        ),
        padding: EdgeInsets.only(top: 15.0),
        margin: EdgeInsets.only(
          top: 100.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(
                appLanguage['whatPost'].toString(),
                style: TextStyle(
                  fontSize: 22.0,
                ),
              ),
              SizedBox(height: 20.0),
              _postTypeOption(
                type: appLanguage['general'],
                text: appLanguage['textForGeneralPost'],
                appLanguageText: appLanguage['general'],
                bgColor: true,
                context: context,
                fontSize: fontSize,
                usersProvince: usersProvince,
              ),
              _postTypeOption(
                type: appLanguage['advert'],
                text: appLanguage['textForAdvertPost'],
                appLanguageText: appLanguage['advert'],
                bgColor: false,
                context: context,
                fontSize: fontSize,
                usersProvince: usersProvince,
              ),
              _postTypeOption(
                type: appLanguage['emergency'],
                text: appLanguage['textForEmergencyPost'],
                appLanguageText: appLanguage['emergency'],
                bgColor: true,
                context: context,
                fontSize: fontSize,
                usersProvince: usersProvince,
              ),
              _postTypeOption(
                type: appLanguage['lost'],
                text: appLanguage['textForLostPost'],
                appLanguageText: appLanguage['lost'],
                bgColor: false,
                context: context,
                fontSize: fontSize,
                usersProvince: usersProvince,
              ),
              _postTypeOption(
                type: appLanguage['found'],
                text: appLanguage['textForFoundPost'],
                appLanguageText: appLanguage['found'],
                bgColor: true,
                context: context,
                fontSize: fontSize,
                usersProvince: usersProvince,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _postTypeOption({
    String type,
    String text,
    String appLanguageText,
    bool bgColor,
    context,
    fontSize,
    usersProvince,
  }) {
    return GestureDetector(
      onTap: () {
        type == 'Advert' || type == 'اعلان'
            ? Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdvertPost()),
              )
            : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoneAdvertPost(
                    type: type,
                    edit: false,
                    province: usersProvince,
                  ),
                ),
              );
      },
      child: Container(
        decoration: BoxDecoration(
          color: bgColor ? Colors.grey[200] : Colors.white,
        ),
        height: 75.0,
        child: Center(
          child: RadioListTile(
            subtitle: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),
            isThreeLine: false,
            title: Text(
              appLanguageText,
              style: TextStyle(
                fontSize: 17.0,
                height: 0.5,
              ),
            ),
            value: type,
            groupValue: postType,
            onChanged: (value) {
              onSelectPostType(value);
              type == 'Advert' || type == 'اعلان'
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdvertPost(),
                      ),
                    )
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoneAdvertPost(
                          type: type,
                          edit: false,
                          province: usersProvince,
                        ),
                      ),
                    );
            },
            activeColor: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
