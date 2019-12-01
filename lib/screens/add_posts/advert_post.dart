import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:saheb/providers/postsProvider.dart';
import 'package:saheb/widgets/errorDialog.dart';
import '../../widgets/verticalDivider.dart';
import '../../providers/authProvider.dart';
import '../../locations/locations_sublocations.dart';
import '../../util/uploadImage.dart';
import '../../widgets/locationPicker.dart';
//import 'package:provider/provider.dart';
import '../../widgets/button.dart';
import '../../widgets/showInfoFushbar.dart';
import '../../providers/languageProvider.dart';
import '../../languages/index.dart';
import '../../mixins/add_post.dart';

class AdvertPost extends StatefulWidget {
  @override
  _AdvertPostState createState() => _AdvertPostState();
}

class _AdvertPostState extends State<AdvertPost> with AddPostMixin {
  String dropdownValue;
  String locationDropDownValue;
  String _text;
  String _title;
  String _price;
  String _phone;
  String _email;
  List<File> _images = [];
  List<String> _uploadedFileUrl = [];

  onDropDownChange(value) {
    setState(() {
      dropdownValue = value;
    });
  }

  onLocationChange(value) {
    setState(() {
      locationDropDownValue = value;
    });
  }

  onTextInputChange(value) {
    _text = value;
  }

  onTitleInputChange(value) {
    _title = value;
  }

  onEmailInputChange(value) {
    _email = value;
  }

  onPhoneInputChange(value) {
    _phone = value;
  }

  onPriceInputChange(value) {
    _price = value;
  }

  Future chooseFile(source) async {
    try {
      final image = await ImagePicker.pickImage(
        source: source,
        maxWidth: 600,
        maxHeight: 700,
        imageQuality: 50,
      );
      if (image != null) {
        setState(() {
          _images.add(image);
        });
      }
    } catch (error) {
      print(error);
    }
  }

  deleteSelectedImage(index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  uploadAllImages(images) {
    var futures = List<Future>();
    for (var imageFile in images) {
      futures.add(uploadImage(image: imageFile, collection: 'posts')
          .then((downloadUrl) {
        _uploadedFileUrl.add(downloadUrl);
      }).catchError((err) {
        print(err);
      }));
    }
    return futures;
  }

  onSend() async {
    final appLanguage = getLanguages(context);
    if (_text == null || _title == null || locationDropDownValue == null) {
      showErrorDialog(appLanguage['fillOutRequiredSections'], context,
          appLanguage['emptyForm'], appLanguage['ok']);
      return;
    }

    final flashBarDuration =
        _images.length == 0 ? _images.length : _images.length + 1;
    showInfoFlushbar(
      context: context,
      duration: flashBarDuration,
      message: appLanguage['wait'],
      icon: Icons.file_upload,
      progressBar: true,
      positionTop: true,
    );
    await Future.wait(uploadAllImages(_images));
    final user = await Provider.of<AuthProvider>(context).currentUser;
    final currentUserId =
        Provider.of<AuthProvider>(context, listen: false).userId;
    await Provider.of<PostsProvider>(context, listen: false).addOneAdvert(
      type: dropdownValue,
      text: _text,
      title: _title,
      phone: _phone,
      email: _email,
      price: _price.toString(),
      location: locationDropDownValue,
      owner: {
        'name': user.displayName,
        'id': currentUserId,
        'location': 'Some where in Kabul',
        'photo': user.photoUrl,
      },
      images: _uploadedFileUrl,
    );

    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = getLanguages(context);
    final imagesMax = _images.length > 5 ? true : false;
    final currentLanguage = Provider.of<LanguageProvider>(context).getLanguage;
    double fontSize = currentLanguage == 'English' ? 13.0 : 15.0;

    final List<String> dropDownItems = [
      appLanguage['sell'].toString(),
      appLanguage['rent'].toString(),
      appLanguage['buy'].toString(),
      appLanguage['needPro'].toString()
    ];
    return Scaffold(
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
                height: 28.0,
                fontSize: fontSize,
              ),
            ],
          ),
        ),
      ),
      body: Card(
        color: Colors.white,
        elevation: 10.0,
        margin: EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 5.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          DropDownPicker(
                            onChange: onDropDownChange,
                            value: appLanguage['typeOfDeal'],
                            items: dropDownItems,
                            label: appLanguage['typeOfDeal'],
                            search: false,
                          ),
                          DropDownPicker(
                            search: true,
                            items: locations['kabul'],
                            hintText: appLanguage['location'],
                            label: appLanguage['location'],
                            value: appLanguage['location'],
                            onChange: onLocationChange,
                          ),
                        ],
                      ),
                      postTitle(
                        type: appLanguage['advert'].toString(),
                        appLanguage: appLanguage,
                        onChange: onTitleInputChange,
                        fontSize: fontSize,
                      ),
                      textArea(
                        type: appLanguage['advert'].toString(),
                        appLanguage: appLanguage,
                        onChange: onTextInputChange,
                        fontSize: fontSize,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: priceArea(
                              appLanguage: appLanguage,
                              onChange: onPriceInputChange,
                              fontSize: fontSize,
                            ),
                          ),
                          CustomVerticalDivider(),
                          Expanded(
                            child: phoneNumberArea(
                              appLanguage: appLanguage,
                              onChange: onPhoneInputChange,
                              fontSize: fontSize,
                            ),
                          ),
                        ],
                      ),
                      emailAddressArea(
                        appLanguage: appLanguage,
                        onChange: onEmailInputChange,
                        fontSize: fontSize,
                      ),
                      _images.length != 0
                          ? Row(
                              children: <Widget>[
                                ...photoVideoArea(_images, deleteSelectedImage),
                              ],
                            )
                          : SizedBox(
                              width: 0.0,
                            ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.cyanAccent,
                    width: 0.3,
                  ),
                ),
              ),
              child: bottomBar(
                onSend: onSend,
                onOpenPhotoVideo: chooseFile,
                maxImageSize: imagesMax,
                context: context,
                edit: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
