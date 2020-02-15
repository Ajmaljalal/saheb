import 'dart:io';
import 'dart:async';
import 'dart:ui';
import 'package:com.pywast.pywast/util/uuid.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/locationProvider.dart';
import '../../providers/postsProvider.dart';
import '../../widgets/errorDialog.dart';
import '../../widgets/progressIndicators.dart';
import '../../widgets/verticalDivider.dart';
import '../../providers/authProvider.dart';
import '../../locations/locations_sublocations.dart';
import '../../util/uploadImage.dart';
import '../../widgets/locationPicker.dart';
import '../../widgets/button.dart';
import '../../providers/languageProvider.dart';
import '../../languages/index.dart';
import '../../mixins/add_post.dart';

class AdvertPost extends StatefulWidget {
  @override
  _AdvertPostState createState() => _AdvertPostState();
}

class _AdvertPostState extends State<AdvertPost> with AddPostMixin {
  String _typOfDeal;
  String _location;
  String _text;
  String _title;
  String _price;
  String _phone;
  String _email;
  List<File> _images = [];
  List<String> _uploadedFileUrl = [];

  FocusNode titleFieldFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  FocusNode priceFieldFocusNode = FocusNode();
  FocusNode phoneFieldFocusNode = FocusNode();
  FocusNode emailFieldFocusNode = FocusNode();

  bool advertSavingInProgress = false;

  onDropDownChange(value) {
    setState(() {
      _typOfDeal = value;
    });
  }

  onLocationChange(value) {
    setState(() {
      _location = value;
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
    FocusScope.of(context).unfocus();
    try {
      final image = await ImagePicker.pickImage(
        source: source,
        maxWidth: 600,
        maxHeight: 700,
        imageQuality: 80,
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
      futures.add(uploadImage(image: imageFile, collection: 'adverts')
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
    if (_location == null) {
      showErrorDialog(
        appLanguage['selectLocation'],
        context,
        appLanguage['emptyForm'],
        appLanguage['ok'],
      );
      return;
    }
    if ((_text == null || _text.trim().length == 0) ||
        (_title == null || _title.trim().length == 0) ||
        _typOfDeal == null ||
        _images.length == 0) {
      showErrorDialog(
        appLanguage['fillOutRequiredSectionsOther'],
        context,
        appLanguage['emptyForm'],
        appLanguage['ok'],
      );
      return;
    }
    final newAdvertId = Uuid().generateV4();
    final newAdvertDate = DateTime.now();
    setState(() {
      advertSavingInProgress = true;
    });
    if (_images != null) {
      await Future.wait(uploadAllImages(_images));
    }
    final user = await Provider.of<AuthProvider>(context).currentUser;
    final currentUserId =
        Provider.of<AuthProvider>(context, listen: false).userId;
    final userLocation = Provider.of<LocationProvider>(context).getUserLocality;
    await Provider.of<PostsProvider>(context, listen: false).addOneAdvert(
      id: newAdvertId,
      date: newAdvertDate,
      type: _typOfDeal,
      text: _text,
      title: _title,
      phone: _phone,
      email: _email,
      price: _price.toString(),
      location: _location,
      owner: {
        'name': user.displayName,
        'id': currentUserId,
        'location': userLocation,
        'photo': user.photoUrl,
      },
      images: _uploadedFileUrl,
    );

    await Provider.of<PostsProvider>(context, listen: false).saveRecordSnapshot(
      id: newAdvertId,
      date: newAdvertDate,
      location: _location,
      type: _typOfDeal,
      collection: 'ids_adverts',
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = getLanguages(context);
    final imagesMax = _images.length > 5 ? true : false;
    final currentLanguage = Provider.of<LanguageProvider>(context).getLanguage;
    final userProvince = Provider.of<LocationProvider>(context).getUserProvince;
    double fontSize = currentLanguage == 'English' ? 13.0 : 15.0;

    final List<String> dropDownItems = [
      appLanguage['sell'].toString(),
      appLanguage['buy'].toString(),
      appLanguage['rent'].toString(),
    ];
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
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
      ),
      body: Card(
        color: Colors.white,
        elevation: 10.0,
        margin: const EdgeInsets.symmetric(
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
                      Column(
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
                            items: locations[userProvince],
                            hintText: appLanguage['location'],
                            label: appLanguage['location'],
                            value: appLanguage['location'],
                            onChange: onLocationChange,
                          ),
                        ],
                      ),
                      postTitle(
                        type: 'advert',
                        appLanguage: appLanguage,
                        onChange: onTitleInputChange,
                        fontSize: fontSize,
                        focusNode: titleFieldFocusNode,
                      ),
                      textArea(
                        type: 'advert',
                        appLanguage: appLanguage,
                        onChange: onTextInputChange,
                        fontSize: fontSize,
                        focusNode: textFieldFocusNode,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: priceArea(
                              appLanguage: appLanguage,
                              onChange: onPriceInputChange,
                              fontSize: fontSize,
                              focusNode: priceFieldFocusNode,
                            ),
                          ),
                          CustomVerticalDivider(),
                          Expanded(
                            child: phoneNumberArea(
                              appLanguage: appLanguage,
                              onChange: onPhoneInputChange,
                              fontSize: fontSize,
                              focusNode: phoneFieldFocusNode,
                            ),
                          ),
                        ],
                      ),
                      emailAddressArea(
                        appLanguage: appLanguage,
                        onChange: onEmailInputChange,
                        fontSize: fontSize,
                        focusNode: emailFieldFocusNode,
                      ),
                      _images.length != 0
                          ? Row(
                              children: <Widget>[
                                ...selectedPhotosVideosHolder(
                                    _images, deleteSelectedImage),
                              ],
                            )
                          : const SizedBox(
                              width: 0.0,
                            ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                border: const Border(
                  top: const BorderSide(
                    color: Colors.cyanAccent,
                    width: 0.3,
                  ),
                ),
              ),
              child: advertSavingInProgress
                  ? linearProgressIndicator()
                  : bottomBar(
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
