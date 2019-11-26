import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../util/resourcePicker.dart';
//import 'package:provider/provider.dart';
import '../widgets/button.dart';
//import '../providers/languageProvider.dart';
import '../languages/index.dart';

class AddPostMixin {
  Widget postTitle({
    type,
    appLanguage,
    onChange,
    fontSize,
  }) {
    final label = type == appLanguage['advert']
        ? appLanguage['advertPostTitle']
        : appLanguage['postTitle'];
    return TextField(
      onChanged: onChange,
      style: TextStyle(
        fontSize: fontSize,
      ),
      decoration: InputDecoration(
        labelText: label.toString(),
        labelStyle: TextStyle(
          fontSize: fontSize,
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 10.0,
        ),
      ),
    );
  }

  Widget textArea({
    type,
    appLanguage,
    onChange,
    fontSize,
  }) {
    final label = type == appLanguage['advert']
        ? appLanguage['advertPostDiscription']
        : appLanguage['postDiscription'];
    return TextField(
      onChanged: onChange,
      maxLines: 5,
      style: TextStyle(
        fontSize: fontSize,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: fontSize,
        ),
        alignLabelWithHint: true,
        contentPadding: EdgeInsets.symmetric(
          vertical: 0.0,
          horizontal: 10.0,
        ),
      ),
    );
  }

  Widget phoneNumberArea({
    appLanguage,
    onChange,
    fontSize,
  }) {
    return Container(
      child: TextField(
        onChanged: onChange,
        style: TextStyle(
          height: 0.95,
          fontSize: fontSize,
        ),
        decoration: InputDecoration(
          labelText: appLanguage['phone'],
          labelStyle: TextStyle(
            fontSize: fontSize,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
        ),
      ),
    );
  }

  Widget emailAddressArea({
    appLanguage,
    onChange,
    fontSize,
  }) {
    return Container(
      child: TextField(
        onChanged: onChange,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          height: 0.95,
          fontSize: fontSize,
        ),
        decoration: InputDecoration(
          labelText: appLanguage['optionalEmail'].toString(),
          labelStyle: TextStyle(
            fontSize: fontSize,
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
    fontSize,
  }) {
    return Container(
      child: TextField(
        onChanged: onChange,
        style: TextStyle(
          height: 0.95,
          fontSize: fontSize,
        ),
        decoration: InputDecoration(
          labelText: appLanguage['price'],
          labelStyle: TextStyle(
            fontSize: fontSize,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
        ),
      ),
    );
  }

  List photoVideoArea(
    images,
    deleteSelectedImage,
  ) {
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
              onPressed: () async {
                if (maxImageSize == false) {
                  await onOpenPhotoVideo(ImageSource.camera);
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
              onPressed: () async {
                if (maxImageSize == false) {
                  await onOpenPhotoVideo(ImageSource.gallery);
                } else {
                  return;
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
