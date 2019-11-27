import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saheb/providers/postsProvider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flushbar/flushbar.dart';
import 'package:saheb/widgets/errorDialog.dart';
import '../../providers/authProvider.dart';
import '../../widgets/locationPicker.dart';
import '../../locations/locations_sublocations.dart';
import '../../widgets/button.dart';
import '../../util/uploadImage.dart';
//import '../../providers/languageProvider.dart';
import '../../languages/index.dart';
import '../../mixins/add_post.dart';

class NoneAdvertPost extends StatefulWidget {
  final String type;
  NoneAdvertPost(this.type);
  @override
  State createState() => _NoneAdvertPostState();
}

class _NoneAdvertPostState extends State<NoneAdvertPost> with AddPostMixin {
  String _text;
  String _title;
  String _location;
  List<File> _images = [];
  List<String> _uploadedFileUrl = [];

  onTextInputChange(value) {
    _text = value;
  }

  onTitleInputChange(value) {
    _title = value;
  }

  onLocationChange(value) {
    _location = value;
  }

  Future chooseFile(source) async {
    try {
      final image = await ImagePicker.pickImage(
          source: source, imageQuality: 80, maxWidth: 600, maxHeight: 900);
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
    final appLanguage = getLanguages(context);

    if (_text == null || _title == null || _location == null) {
      showErrorDialog(appLanguage['fillOutRequiredSections'], context,
          appLanguage['emptyForm'], appLanguage['ok']);
      return;
    }

    final flashBarDuration =
        _images.length == 0 ? _images.length : _images.length + 1;
    showInfoFlushbarHelper(context, flashBarDuration, appLanguage['wait']);
    await Future.wait(uploadAllImages(_images));
    final user = await Provider.of<AuthProvider>(context).currentUser;
    final currentUserId =
        Provider.of<AuthProvider>(context, listen: false).userId;
    await Provider.of<PostsProvider>(context, listen: false).addOnePost(
      type: widget.type,
      text: _text,
      title: _title,
      location: _location,
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
    final type = widget.type;
//    final _language = Provider.of<LanguageProvider>(context).getLanguage;
    final appLanguage = getLanguages(context);
    final imagesMax = _images.length > 5 ? true : false;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, true),
        ),
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('$type'),
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
          vertical: 5.0,
          horizontal: 15.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      DropDownPicker(
                        onChange: onLocationChange,
                        value: appLanguage['location'],
                        items: locations['kabul'],
                        hintText: appLanguage['location'],
                        label: appLanguage['location'],
                        search: true,
                      ),
                      postTitle(
                        type: appLanguage['general'],
                        appLanguage: appLanguage,
                        onChange: onTitleInputChange,
                      ),
                      textArea(
                        type: appLanguage['general'],
                        appLanguage: appLanguage,
                        onChange: onTextInputChange,
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
                context: context,
                maxImageSize: imagesMax,
                appLanguage: appLanguage,
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
      backgroundColor: Colors.white,
      boxShadows: [
        BoxShadow(
            color: Colors.black, offset: Offset(0.0, 2.0), blurRadius: 3.0)
      ],
//      backgroundGradient:
//          LinearGradient(colors: [Colors.cyanAccent, Colors.cyan]),
      isDismissible: false,
      duration: Duration(seconds: duration),
      icon: Icon(
        Icons.file_upload,
        color: Colors.green,
      ),
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: Colors.blueGrey,
      messageText: Center(
        child: Text(
          message.toString(),
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.black,
          ),
        ),
      ),
    ).show(context);
  }
}
