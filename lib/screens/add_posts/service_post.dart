import 'dart:io';
import 'dart:async';
import 'package:com.pywast.pywast/util/uuid.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/locationProvider.dart';
import '../../providers/postsProvider.dart';
import '../../util/mapPostTypes.dart';
import '../../widgets/errorDialog.dart';
import '../../widgets/progressIndicators.dart';
import '../../providers/authProvider.dart';
import '../../locations/locations_sublocations.dart';
import '../../util/uploadImage.dart';
import '../../widgets/locationPicker.dart';
import '../../widgets/button.dart';
import '../../providers/languageProvider.dart';
import '../../languages/index.dart';
import '../../mixins/add_post.dart';

class ServicePost extends StatefulWidget {
  @override
  _ServicePostState createState() => _ServicePostState();
}

class _ServicePostState extends State<ServicePost> with AddPostMixin {
  String _typeOfService;
  String _location;
  String _desc;
  String _title;
  String _fullAddress;
  String _phone;
  String _email;
  List<File> _images = [];
  List<String> _uploadedFileUrl = [];

  FocusNode titleFieldFocusNode = FocusNode();
  FocusNode descFieldFocusNode = FocusNode();
  FocusNode fullAddressFieldFocusNode = FocusNode();
  FocusNode phoneFieldFocusNode = FocusNode();
  FocusNode emailFieldFocusNode = FocusNode();

  bool serviceSavingInProgress = false;

  onDropDownChange(value, appLanguage) {
    setState(() {
      _typeOfService = mapPostType(value.toLowerCase(), appLanguage);
    });
  }

  onLocationChange(value) {
    setState(() {
      _location = value;
    });
  }

  onDescInputChange(value) {
    _desc = value;
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

  onFullAddressInputChange(value) {
    _fullAddress = value;
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
      futures.add(uploadImage(image: imageFile, collection: 'services')
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
    if ((_desc == null || _desc.trim().length == 0) ||
        (_title == null || _title.trim().length == 0) ||
        _typeOfService == null) {
      showErrorDialog(
        appLanguage['fillOutRequiredSectionsOther'],
        context,
        appLanguage['emptyForm'],
        appLanguage['ok'],
      );
      return;
    }

    final newServiceId = Uuid().generateV4();
    final newServiceDate = DateTime.now();

    setState(() {
      serviceSavingInProgress = true;
    });

    await Future.wait(uploadAllImages(_images));
    final user = await Provider.of<AuthProvider>(context).currentUser;
    final currentUserId =
        Provider.of<AuthProvider>(context, listen: false).userId;
    final userLocation = Provider.of<LocationProvider>(context).getUserLocality;
    await Provider.of<PostsProvider>(context, listen: false).addOneService(
      id: newServiceId,
      date: newServiceDate,
      type: _typeOfService,
      desc: _desc,
      title: _title,
      phone: _phone,
      email: _email,
      fullAddress: _fullAddress,
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
      id: newServiceId,
      date: newServiceDate,
      location: _location,
      type: _typeOfService,
      collection: 'ids_services',
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

    final List<String> serviceTypDropDownItems = [
      appLanguage['health'].toString(),
      appLanguage['education'].toString(),
      appLanguage['painting'].toString(),
      appLanguage['construction'].toString(),
      appLanguage['carpenter'].toString(),
      appLanguage['electrician'].toString(),
      appLanguage['mechanic'].toString(),
      appLanguage['cleaning'].toString(),
      appLanguage['plumber'].toString(),
      appLanguage['laundry'].toString(),
      appLanguage['computer'].toString(),
      appLanguage['transportation'].toString(),
      appLanguage['legal'].toString(),
      appLanguage['decoration'].toString(),
      appLanguage['cosmetics'].toString(),
    ];
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('${appLanguage['services'].toString()}'),
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
                            onChange: (value) {
                              onDropDownChange(value, appLanguage);
                            },
                            value: appLanguage['typeOfService'],
                            items: serviceTypDropDownItems,
                            label: appLanguage['typeOfService'],
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
                        type: 'service',
                        appLanguage: appLanguage,
                        onChange: onTitleInputChange,
                        fontSize: fontSize,
                        focusNode: titleFieldFocusNode,
                      ),
                      textArea(
                        type: 'service',
                        appLanguage: appLanguage,
                        onChange: onDescInputChange,
                        fontSize: fontSize,
                        focusNode: descFieldFocusNode,
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            child: fullAddressArea(
                              appLanguage: appLanguage,
                              onChange: onFullAddressInputChange,
                              fontSize: fontSize,
                              focusNode: fullAddressFieldFocusNode,
                            ),
                          ),
                          Container(
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
            serviceSavingInProgress
                ? linearProgressIndicator()
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      border: const Border(
                        top: const BorderSide(
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
