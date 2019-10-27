import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import '../widgets/button.dart';
//import '../providers/languageProvider.dart';
import '../languages/index.dart';

class AddPostMixin {
  Widget typeOfBusinessOptions(
      {onDropDownChange, dropdownValue, dropdownItems, appLanguage, context}) {
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
//        hint: Text('${appLanguage['typeOfTransaction']}'),
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

  Widget postTitle(type, appLanguage) {
    final label = type == appLanguage['advert']
        ? appLanguage['advertPostTitle']
        : appLanguage['postTitle'];
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

  Widget textArea(type, appLanguage) {
    final label = type == appLanguage['advert']
        ? appLanguage['advertPostDiscription']
        : appLanguage['postDiscription'];
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

  Widget phoneNumberArea(appLanguage) {
    return Container(
      child: TextField(
        style: TextStyle(
          height: 0.95,
          fontSize: 20.0,
        ),
        decoration: InputDecoration(
          labelText: appLanguage['phone'],
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

  Widget emailAddressArea(appLanguage) {
    return Container(
      child: TextField(
        style: TextStyle(
          height: 0.95,
          fontSize: 20.0,
        ),
        decoration: InputDecoration(
          labelText: appLanguage['optionalEmail'],
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
    final appLanguage = getLanguages(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        customButton(
          appLanguage: appLanguage,
          context: context,
          onClick: onSend,
          forText: 'send',
          width: MediaQuery.of(context).size.width * 0.2,
          height: 32.0,
        ),
        FlatButton(
          child: Text(
            appLanguage['addPhotoVideo'],
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
