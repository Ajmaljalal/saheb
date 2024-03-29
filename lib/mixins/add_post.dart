import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/emptyBox.dart';
import '../widgets/button.dart';
import '../languages/index.dart';

class AddPostMixin {
  Widget postTitle({
    type,
    appLanguage,
    onChange,
    fontSize,
    initialValue,
    focusNode,
  }) {
    String label;
    if (type == 'advert') {
      label = appLanguage['advertPostTitle'];
    }
    if (type == 'service') {
      label = appLanguage['serviceTitle'];
    }
    if (type == 'post') {
      label = appLanguage['postTitle'];
    }
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChange,
      focusNode: focusNode,
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
    initialValue,
    focusNode,
  }) {
    String label;
    if (type == 'advert') {
      label = appLanguage['advertPostDiscription'];
    }
    if (type == 'service') {
      label = appLanguage['serviceDesc'];
    }
    if (type == 'post') {
      label = appLanguage['whatPost'];
    }
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChange,
      focusNode: focusNode,
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
    focusNode,
  }) {
    return Container(
      child: TextField(
        onChanged: onChange,
        focusNode: focusNode,
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

  Widget fullAddressArea({
    appLanguage,
    onChange,
    fontSize,
    focusNode,
  }) {
    return Container(
      child: TextField(
        onChanged: onChange,
        focusNode: focusNode,
        style: TextStyle(
          height: 0.95,
          fontSize: fontSize,
        ),
        decoration: InputDecoration(
          labelText: appLanguage['fullAddress'],
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
    focusNode,
  }) {
    return Container(
      child: TextField(
        onChanged: onChange,
        focusNode: focusNode,
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
    focusNode,
  }) {
    return Container(
      child: TextField(
        onChanged: onChange,
        focusNode: focusNode,
        maxLength: 18,
        style: TextStyle(
          height: 0.95,
          fontSize: fontSize,
        ),
        decoration: InputDecoration(
          counterText: "",
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

  List selectedPhotosVideosHolder(
    images,
    deleteSelectedImage,
  ) {
    return images.map((image) {
      final index = images.indexOf(image);
      if (image != null) {
        return Container(
          margin: EdgeInsets.only(
            top: 5.0,
          ),
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 5.0,
                  horizontal: 4.0,
                ),
                child: Image.file(
                  image,
                  height: 40,
                  width: 40,
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      30.0,
                    ),
                    color: Colors.purple,
                  ),
                  child: Center(
                    child: Text(
                      'x',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      } else
        return emptyBox();
    }).toList();
  }

  Widget bottomBar({
    onSend,
    onOpenPhotoVideo,
    context,
    maxImageSize,
    appLanguage,
    edit,
  }) {
    final appLanguage = getLanguages(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        customButton(
          appLanguage: appLanguage,
          context: context,
          onClick: onSend,
          forText: edit ? 'save' : 'send',
          width: MediaQuery.of(context).size.width * 0.2,
          height: 32.0,
        ),
        Row(
          children: <Widget>[
            maxImageSize
                ? Text(appLanguage['6ImagesSelected'].toString())
                : emptyBox(),
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
