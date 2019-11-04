import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:saheb/providers/postsProvider.dart';
import '../../providers/authProvider.dart';
import 'package:flushbar/flushbar.dart';
import '../../util/uploadImage.dart';
//import 'package:provider/provider.dart';
import '../../widgets/button.dart';
//import '../../providers/languageProvider.dart';
import '../../languages/index.dart';
import '../../mixins/add_post.dart';

class AdvertPost extends StatefulWidget {
  @override
  _AdvertPostState createState() => _AdvertPostState();
}

class _AdvertPostState extends State<AdvertPost> with AddPostMixin {
  String dropdownValue = 'نوع معامله';
  String _text;
  String _title;
  String _price;
  String _phone;
  String _email;
  List<File> _images = [];
  List<String> _uploadedFileUrl = [];
  final List<String> dropDownItems = [
    'نوع معامله',
    'Sell',
    'Rent',
    'Buy',
    'Need for a professional'
  ];

  onDropDownChange(value) {
    setState(() {
      dropdownValue = value;
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
      final image = await ImagePicker.pickImage(source: source);
      setState(() {
        _images.add(image);
      });
    } catch (error) {
      print(error.toString());
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
    if (_text == null && _title == null) {
      return;
    }
    final appLanguage = getLanguages(context);
    final flashBarDuration =
        _images.length == 0 ? _images.length : _images.length + 1;
    showInfoFlushbarHelper(context, flashBarDuration, appLanguage['wait']);
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
      location: 'someLocation',
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
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
              ),
            ],
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 15.0,
        ),
        height: MediaQuery.of(context).size.height * 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      typeOfBusinessOptions(
                        onDropDownChange: onDropDownChange,
                        dropdownValue: dropdownValue,
                        dropdownItems: dropDownItems,
                        context: context,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      postTitle(
                        type: appLanguage['advert'].toString(),
                        appLanguage: appLanguage,
                        onChange: onTitleInputChange,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      textArea(
                        type: appLanguage['advert'].toString(),
                        appLanguage: appLanguage,
                        onChange: onTextInputChange,
                      ),
                      phoneNumberArea(
                        appLanguage: appLanguage,
                        onChange: onPhoneInputChange,
                      ),
                      emailAddressArea(
                        appLanguage: appLanguage,
                        onChange: onEmailInputChange,
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
              child: bottomBar(
                onSend: onSend,
                onOpenPhotoVideo: chooseFile,
                maxImageSize: imagesMax,
                context: context,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showInfoFlushbarHelper(BuildContext context, duration, message) {
    Flushbar(
//      message: 'uploading images',
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundColor: Colors.red,
      boxShadows: [
        BoxShadow(
            color: Colors.blue[800], offset: Offset(0.0, 2.0), blurRadius: 3.0)
      ],
      backgroundGradient:
          LinearGradient(colors: [Colors.cyanAccent, Colors.cyan]),
      isDismissible: false,
      duration: Duration(seconds: duration),
      icon: Icon(
        Icons.file_upload,
        color: Colors.purple,
      ),
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: Colors.blueGrey,
      messageText: Center(
        child: Text(
          message.toString(),
          style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontFamily: "ShadowsIntoLightTwo"),
        ),
      ),
    ).show(context);
  }
}
