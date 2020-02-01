import 'dart:io';
import 'package:com.pywast.pywast/util/uuid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/locationProvider.dart';
import '../../providers/postsProvider.dart';
import '../../widgets/errorDialog.dart';
import '../../widgets/progressIndicators.dart';
import '../../providers/authProvider.dart';
import '../../widgets/locationPicker.dart';
import '../../locations/locations_sublocations.dart';
import '../../widgets/button.dart';
import '../../util/uploadImage.dart';
import '../../languages/index.dart';
import '../../mixins/add_post.dart';
import '../../widgets/emptyBox.dart';

class NoneAdvertPost extends StatefulWidget {
  final Map post;
  final postId;
  final bool edit;
  final province;
  NoneAdvertPost({
    this.postId,
    @required this.edit,
    this.post,
    this.province,
  });
  @override
  State createState() => _NoneAdvertPostState();
}

class _NoneAdvertPostState extends State<NoneAdvertPost> with AddPostMixin {
  String _text;
  String _location;
  List<File> _images = [];
  List _uploadedFileUrl = [];

  FocusNode titleFieldFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();

  bool postSavingInProgress = false;

  @override
  initState() {
    super.initState();
    if (widget.edit == true) {
      setState(() {
        _text = widget.post['text'];
        _location = widget.post['location'];
        _uploadedFileUrl = List.from(widget.post['images']);
      });
    } else
      return;
  }

  onTextInputChange(value) {
    _text = value;
  }

  onLocationChange(value) {
    _location = value;
  }

  Future chooseFile(source) async {
    FocusScope.of(context).unfocus();
    try {
      final image = await ImagePicker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() {
          _images.add(image);
        });
      }
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
    if (_location == null) {
      showErrorDialog(
        appLanguage['selectLocation'],
        context,
        appLanguage['emptyForm'],
        appLanguage['ok'],
      );
      return;
    }

    if ((_text == null || _text.trim().length == 0) && _images.length == 0) {
      showErrorDialog(
        appLanguage['fillOutRequiredSectionsPost'],
        context,
        appLanguage['emptyForm'],
        appLanguage['ok'],
      );
      return;
    }
    final newPostId = Uuid().generateV4();
    final newPostDate = DateTime.now();
    setState(() {
      postSavingInProgress = true;
    });

    if (_images.length > 0) {
      await Future.wait(uploadAllImages(_images));
    }

    final user = await Provider.of<AuthProvider>(context).currentUser;
    final currentUserId =
        Provider.of<AuthProvider>(context, listen: false).userId;
    final userLocality =
        Provider.of<LocationProvider>(context, listen: false).getUserLocality;
    await Provider.of<PostsProvider>(context, listen: false).addOnePost(
      id: newPostId,
      date: newPostDate,
      text: _text,
      location: _location,
      owner: {
        'name': user.displayName,
        'id': currentUserId,
        'location': userLocality,
        'photo': user.photoUrl,
      },
      images: _uploadedFileUrl,
    );
    await Provider.of<PostsProvider>(context, listen: false).savePostSnapshot(
      id: newPostId,
      date: newPostDate,
      location: _location,
      collection: 'ids_posts',
    );
    Navigator.of(context).pop();
  }

  onEdit() async {
    final appLanguage = getLanguages(context);

    if (_location == null || _location.length == 0) {
      showErrorDialog(
        appLanguage['fillOutRequiredSections'],
        context,
        appLanguage['emptyForm'],
        appLanguage['ok'],
      );
      return;
    }

    if ((_text == null || _text.length == 0) && _images.length == 0) {
      showErrorDialog(
        appLanguage['fillOutRequiredSections'],
        context,
        appLanguage['emptyForm'],
        appLanguage['ok'],
      );
      return;
    }

    setState(() {
      postSavingInProgress = true;
    });

    if (_images.length > 0) {
      await Future.wait(uploadAllImages(_images));
    }

    final post = widget.post;

    Provider.of<PostsProvider>(context, listen: false).editOnePost(
      postId: widget.postId,
      location: _location,
      text: _text,
      owner: post['owner'],
      images: _uploadedFileUrl,
      comments: post['comments'],
      likes: post['likes'],
      favorites: post['favorites'],
      hiddenFrom: post['hiddenFrom'],
      date: post['date'],
      promoted: post['promoted'],
      promoStartDate: post['promoStartDate'],
      promoEndDate: post['promoEndDate'],
      promoMoneyAmount: post['promoMoneyAmount'],
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final edit = widget.edit;
    final post = widget.post;
    final userProvince = widget.province;
    final appLanguage = getLanguages(context);
    final imagesMax = _images.length > 5 ? true : false;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, true),
          ),
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(appLanguage['addNewPost']),
                customButton(
                  appLanguage: appLanguage,
                  context: context,
                  onClick: onSend,
                  forText: edit ? 'save' : 'send',
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: 28.0,
                ),
              ],
            ),
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
                        value:
                            edit ? post['location'] : appLanguage['location'],
                        items: locations[userProvince],
                        hintText: appLanguage['location'],
                        label: appLanguage['location'],
                        search: true,
                      ),
                      textArea(
                        type: 'post',
                        appLanguage: appLanguage,
                        onChange: onTextInputChange,
                        initialValue: edit ? post['text'] : '',
                        focusNode: textFieldFocusNode,
                      ),
                      _images.length != 0
                          ? Row(
                              children: <Widget>[
                                ...selectedPhotosVideosHolder(
                                    _images, deleteSelectedImage),
                              ],
                            )
                          : emptyBox(),
                    ],
                  ),
                ),
              ),
            ),
            postSavingInProgress
                ? linearProgressIndicator()
                : Container(
                    child: bottomBar(
                      onSend: edit ? onEdit : onSend,
                      onOpenPhotoVideo: chooseFile,
                      context: context,
                      maxImageSize: imagesMax,
                      appLanguage: appLanguage,
                      edit: edit,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
