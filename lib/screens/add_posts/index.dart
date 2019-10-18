import 'package:flutter/material.dart';
import 'advert_post.dart';
import 'none_advert_post.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  String postType = '';

  onSelectPostType(value) {
    setState(() {
      postType = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
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
                'در باره چه می خواهید بنویسید؟',
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
              SizedBox(height: 20.0),
              _postTypeOption(
                type: 'general',
                text: 'مثلاً در باره حوادث عادی از محل بود و باش شما.',
                appLanguageText: 'عمومی',
                bgColor: true,
              ),
              _postTypeOption(
                type: 'advert',
                text: 'مثلاً می خواهید چیزی بخرید، بفروشید و یا به کراه دهید.',
                appLanguageText: 'تجارتی',
                bgColor: false,
              ),
              _postTypeOption(
                type: 'urgent',
                text: 'مثلاً به خون ضرورت است، راه بند است، و حوادث امنیتی.',
                appLanguageText: 'عاجل',
                bgColor: true,
              ),
              _postTypeOption(
                type: 'lost',
                text: 'مثلاً چیزی یا شخصی مفقود ګردیده.',
                appLanguageText: 'مفقودی',
                bgColor: false,
              ),
              _postTypeOption(
                type: 'found',
                text: 'مثلاً چیزی یا شخصی دریافت ګردیده.',
                appLanguageText: 'دریافتی',
                bgColor: true,
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
  }) {
    return GestureDetector(
      onTap: () {
        type != 'advert'
            ? Navigator.push(context,
                MaterialPageRoute(builder: (context) => NoneAdvertPost(type)))
            : Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdvertPost()),
              );
      },
      child: Container(
        decoration: BoxDecoration(
          color: bgColor ? Colors.grey[200] : Colors.white,
        ),
        height: 75.0,
        padding: EdgeInsets.only(bottom: 30.0),
        child: Center(
          child: RadioListTile(
            subtitle: Text(text),
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
              type != 'advert'
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NoneAdvertPost(type)))
                  : Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdvertPost()),
                    );
            },
            activeColor: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
