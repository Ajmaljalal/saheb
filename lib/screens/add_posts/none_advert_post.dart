import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saheb/providers/postsProvider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flushbar/flushbar.dart';
import '../../providers/authProvider.dart';
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
  List<File> _images = [];
  List<String> _uploadedFileUrl = [];

  onTextInputChange(value) {
    _text = value;
  }

  onTitleInputChange(value) {
    _title = value;
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
    await Provider.of<PostsProvider>(context, listen: false).addOnePost(
      type: widget.type,
      text: _text,
      title: _title,
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
      backgroundColor: Colors.grey[100],
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
                      SizedBox(
                        height: 15.0,
                      ),
                      postTitle(
                        type: appLanguage['general'],
                        appLanguage: appLanguage,
                        onChange: onTitleInputChange,
                      ),
                      SizedBox(
                        height: 10.0,
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
