import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/button.dart';
import '../../providers/languageProvider.dart';
import '../../languages/index.dart';
import '../../mixins/add_post.dart';

class NoneAdvertPost extends StatefulWidget {
  final String type;
  NoneAdvertPost(this.type);
  @override
  State createState() => _NoneAdvertPostState();
}

class _NoneAdvertPostState extends State<NoneAdvertPost> with AddPostMixin {
  onSend() {}

  @override
  Widget build(BuildContext context) {
    final type = widget.type;
    final _language = Provider.of<LanguageProvider>(context).getLanguage;
    final appLanguage = getLanguages(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, true),
        ),
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('$type'),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 15.0,
                      ),
                      postTitle('عادی'),
                      SizedBox(
                        height: 10.0,
                      ),
                      textArea('عادی'),
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