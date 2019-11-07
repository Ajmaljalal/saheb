import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        hint: Container(
          padding: EdgeInsets.only(
            right: 10.0,
          ),
          child: Text(
            '${appLanguage['typeOfDeal'].toString()}',
            style: TextStyle(fontFamily: 'ZarReg'),
          ),
        ),
        icon: Icon(
          Icons.arrow_drop_down,
          color: Theme.of(context).accentColor,
        ),
        iconSize: 40.0,
        elevation: 2,
        style: TextStyle(
          color: Colors.black,
          fontSize: 15.0,
          fontFamily: 'ZarReg',
        ),
        underline: Container(
          height: 0.5,
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

  Widget postTitle({type, appLanguage, onChange}) {
    final label = type == appLanguage['advert']
        ? appLanguage['advertPostTitle']
        : appLanguage['postTitle'];
    return TextField(
      onChanged: onChange,
      style: TextStyle(
        height: 0.95,
        fontSize: 20.0,
      ),
      decoration: InputDecoration(
        labelText: label.toString(),
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

  Widget textArea({type, appLanguage, onChange}) {
    final label = type == appLanguage['advert']
        ? appLanguage['advertPostDiscription']
        : appLanguage['postDiscription'];
    return TextField(
      onChanged: onChange,
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

  Widget phoneNumberArea({appLanguage, onChange}) {
    return Container(
      child: TextField(
        onChanged: onChange,
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

  Widget emailAddressArea({appLanguage, onChange}) {
    return Container(
      child: TextField(
        onChanged: onChange,
        style: TextStyle(
          height: 0.95,
          fontSize: 20.0,
        ),
        decoration: InputDecoration(
          labelText: appLanguage['optionalEmail'].toString(),
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

  Widget priceArea({
    appLanguage,
    onChange,
  }) {
    return Container(
      child: TextField(
        onChanged: onChange,
        style: TextStyle(
          height: 0.95,
          fontSize: 20.0,
        ),
        decoration: InputDecoration(
          labelText: appLanguage['price'],
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

  List photoVideoArea(images, deleteSelectedImage) {
    return images.map((image) {
      final index = images.indexOf(image);
      if (image != null) {
        return Container(
          margin: EdgeInsets.only(
            top: 10.0,
          ),
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 5.0,
                  horizontal: 5.0,
                ),
                child: Image.file(
                  image,
                  height: 50,
                  width: 50,
                  filterQuality: FilterQuality.low,
                  fit: BoxFit.cover,
                ),
              ),
              GestureDetector(
                onTap: () {
                  deleteSelectedImage(index);
                },
                child: Container(
                  width: 20.0,
                  height: 20.0,
//                padding: EdgeInsets.only(right: 10.0, top: 5.0),
                  color: Colors.purple,
                  child: Center(
                    child: Text(
                      'X',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      } else
        return Text('');
    }).toList();
  }

  Widget bottomBar({
    onSend,
    onOpenPhotoVideo,
    context,
    maxImageSize,
    appLanguage,
  }) {
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
//        FlatButton(
        Row(
          children: <Widget>[
            maxImageSize
                ? Text(appLanguage['6ImagesSelected'].toString())
                : Text(appLanguage['select6Images'].toString()),
            IconButton(
              icon: Icon(
                Icons.photo_camera,
                color: maxImageSize ? Colors.grey : Colors.black,
              ),
              onPressed: () {
                if (maxImageSize == false) {
                  onOpenPhotoVideo(ImageSource.camera);
                } else {
                  return;
                }
              },
            ),
            IconButton(
              icon: Icon(
                Icons.photo_library,
                color: maxImageSize ? Colors.grey : Colors.black,
              ),
              onPressed: () {
                if (maxImageSize == false) {
                  onOpenPhotoVideo(ImageSource.gallery);
                } else {
                  return;
                }
              },
            ),
          ],
        ),
//          onPressed: onOpenPhotoVideo,
//        ),
      ],
    );
  }
}
