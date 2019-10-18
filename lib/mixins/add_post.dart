import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/button.dart';
import '../providers/languageProvider.dart';
import '../languages/index.dart';

class AddPostMixin {
  Widget typeOfBusinessOptions(
      {onDropDownChange, dropdownValue, dropdownItems, context}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.cyanAccent),
        borderRadius: BorderRadius.circular(
          10.0,
        ),
      ),
      child: DropdownButton(
        value: dropdownValue,
        isExpanded: true,
        hint: Text('نوع معامله'),
        icon: Icon(
          Icons.arrow_drop_down,
          color: Theme.of(context).accentColor,
        ),
        iconSize: 40.0,
        elevation: 2,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
        ),
        underline: Container(
          height: 1,
          color: Colors.grey[100],
        ),
        onChanged: onDropDownChange,
        items: <String>[...dropdownItems]
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Center(
              child: Text(
                value,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget postTitle(type) {
    final label = type == 'تجارتی'
        ? 'عنوان: (مثلاً موتر فروشی، خانه کرایی و غیره...)'
        : 'عنوان...';
    return TextField(
      style: TextStyle(
        height: 0.95,
        fontSize: 20.0,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 15.0,
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 10.0,
        ),
      ),
    );
  }

  Widget textArea(type) {
    final label = type == 'تجارتی'
        ? 'تشریح: (مثلا رنګ، سال، مستعمل، جدید و غیره...)'
        : 'مطلب...';
    return TextField(
      maxLines: 5,
      style: TextStyle(
        fontSize: 20.0,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 15.0,
        ),
        alignLabelWithHint: true,
        contentPadding: EdgeInsets.symmetric(
          vertical: 0.0,
          horizontal: 10.0,
        ),
      ),
    );
  }

  Widget phoneNumberArea() {
    return Container(
      child: TextField(
        style: TextStyle(
          height: 0.95,
          fontSize: 20.0,
        ),
        decoration: InputDecoration(
          labelText: 'نمبر موبایل (اختیاری):',
          labelStyle: TextStyle(
            fontSize: 15.0,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
        ),
      ),
    );
  }

  Widget emailAddressArea() {
    return Container(
      child: TextField(
        style: TextStyle(
          height: 0.95,
          fontSize: 20.0,
        ),
        decoration: InputDecoration(
          labelText: 'ایمیل آدرس (اختیاری):',
          labelStyle: TextStyle(
            fontSize: 15.0,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
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
          height: 32.0,
        ),
        FlatButton(
          child: Text(
            'Add Photo/Video',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          onPressed: onOpenPhotoVideo,
        ),
      ],
    );
  }
}
