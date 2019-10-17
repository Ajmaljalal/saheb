import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/button.dart';
import '../providers/languageProvider.dart';
import '../languages/index.dart';

class AddPostMixin {
  Widget postTitle() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'عنوان...',
        contentPadding: EdgeInsets.symmetric(
          vertical: 0.0,
          horizontal: 10.0,
        ),
      ),
    );
  }

  Widget textArea() {
    return TextField(
      maxLines: 5,
      textAlignVertical: TextAlignVertical.top,
      decoration: InputDecoration(
        labelText: 'مطلب...',
        alignLabelWithHint: true,
        contentPadding: EdgeInsets.symmetric(
          vertical: 0.0,
          horizontal: 10.0,
        ),
      ),
    );
  }

  Widget photoVideoArea(url) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 5.0,
      ),
      child: Image.network(
        url,
        height: 70,
        width: 70,
        filterQuality: FilterQuality.low,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget bottomBar({onSend, onOpenPhotoVideo, context}) {
    final _language = Provider.of<LanguageProvider>(context).getLanguage;
    final appLanguage = getLanguages(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        customButton(
          userLanguage: _language,
          appLanguage: appLanguage,
          context: context,
          onClick: onSend,
          forText: 'send',
          width: MediaQuery.of(context).size.width * 0.2,
          height: 30.0,
        ),
        FlatButton(
          child: Text('Add Photo/Video'),
          onPressed: onOpenPhotoVideo,
        ),
      ],
    );
  }
}
