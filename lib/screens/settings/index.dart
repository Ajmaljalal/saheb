import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../providers/locationProvider.dart';
import '../../providers/postsProvider.dart';
import '../../screens/settings/changeLocation.dart';
import '../../util/uploadImage.dart';
import '../../widgets/progressIndicators.dart';
import '../../widgets/emptyBox.dart';
import '../../widgets/avatar.dart';
import '../../widgets/userNameHolder.dart';
import '../../widgets/userLocationHolder.dart';
import '../../widgets/button.dart';
import '../../providers/languageProvider.dart';
import '../../providers/authProvider.dart';
import '../../languages/index.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String appLanguageOption;
  File userImage;
  String userPhotoUrl;
  String locality;
  String province;

  Future chooseFile({source, userId}) async {
    FocusScope.of(context).unfocus();
    try {
      final image = await ImagePicker.pickImage(
        source: source,
        maxWidth: 100,
        maxHeight: 100,
        imageQuality: 80,
      );
      if (image != null) {
        updateUserPhoto(imageFile: image, userId: userId);
      }
    } catch (error) {
      print(error);
    }
  }

  updateUserPhoto({imageFile, userId}) {
    uploadImage(image: imageFile, collection: 'users').then(
      (downloadUrl) async {
        await Provider.of<PostsProvider>(context).updateUserInfo(
          userId: userId,
          field: 'photoUrl',
          value: downloadUrl,
          context: context,
        );
      },
    ).catchError(
      (err) {
        print(err);
      },
    );
  }

  onChangeUserLocality(value) {
    setState(() {
      locality = value;
    });
  }

  onChangeUserProvince(value) {
    setState(() {
      province = value;
    });
  }

  void updateUserLocation({
    userLocality,
    userProvince,
  }) async {
    final currentUserId = Provider.of<AuthProvider>(context).userId;
    await Provider.of<LocationProvider>(context)
        .changeUserLocality(userLocality);
    await Provider.of<LocationProvider>(context)
        .changeUserProvince(userProvince);
    await Provider.of<PostsProvider>(context).updateUserInfo(
      userId: currentUserId,
      field: 'location',
      value: userLocality,
      context: context,
    );
  }

  onChangeAppLanguage(value) async {
    setState(() {
      appLanguageOption = value;
    });
    await Provider.of<LanguageProvider>(context).changeLanguage(value);
  }

  onSignOut() async {
    await Provider.of<AuthProvider>(context).logout();
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = getLanguages(context);
    final userCurrentLocality =
        Provider.of<LocationProvider>(context).getUserLocality;
    final currentUserId = Provider.of<AuthProvider>(context).userId;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 30.0,
          horizontal: 10.0,
        ),
        child: Column(
          children: <Widget>[
            _userProfile(
              userCurrentLocality,
              currentUserId,
              appLanguage,
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: _settingsOptions(appLanguage),
            ),
            const Divider(color: Colors.black),
            customButton(
              appLanguage: appLanguage,
              context: context,
              onClick: onSignOut,
              forText: 'signOut',
              width: MediaQuery.of(context).size.width * 0.3,
              height: 30.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _userProfile(
    userLocation,
    currentUserId,
    appLanguage,
  ) {
    var user;
    return StreamBuilder(
      stream:
          Provider.of<PostsProvider>(context).getOneUser(userId: currentUserId),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return emptyBox();
        }
        user = userSnapshot.data;
        if (user != null) {
          return Center(
            child: Column(
              children: <Widget>[
                user['photoUrl'] != null
                    ? userAvatarHolder(user['photoUrl'], currentUserId)
                    : emptyBox(),
                userNameHolder(name: user['name'], fontSize: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    userLocationEditor(
                        onTap: renderLocationPicker,
                        context: context,
                        appLanguage: appLanguage),
                    userLocationHolder(userLocation),
                  ],
                ),
              ],
            ),
          );
        } else
          return Center(child: circularProgressIndicator());
      },
    );
  }

  Widget userAvatarHolder(
    userPhoto,
    userId,
  ) {
    return Stack(
      children: <Widget>[
        userAvatar(
          height: 80.0,
          width: 80.0,
          photo: userPhoto,
        ),
        Positioned(
          bottom: 5.0,
          right: 5.0,
          child: InkWell(
            onTap: () {
              chooseFile(source: ImageSource.gallery, userId: userId);
            },
            child: Container(
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  30.0,
                ),
                color: Colors.white,
              ),
              child: const Icon(
                Icons.photo_camera,
                color: Colors.green,
                size: 18.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _settingsOptions(appLanguage) {
    return Center(
      child: _appLanguageOptions(appLanguage),
    );
  }

  Widget _appLanguageOptions(appLanguage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Divider(color: Colors.black),
        Text(
          appLanguage['changeAppLanguage'],
          style: TextStyle(fontSize: 18.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: Row(
                children: <Widget>[
                  Radio(
                    value: 'pashto',
                    groupValue: appLanguageOption,
                    onChanged: onChangeAppLanguage,
                    activeColor: Theme.of(context).accentColor,
                  ),
                  const Text('پښتو'),
                ],
              ),
            ),
            Flexible(
              child: Row(
                children: <Widget>[
                  Radio(
                    value: 'dari',
                    groupValue: appLanguageOption,
                    onChanged: onChangeAppLanguage,
                    activeColor: Theme.of(context).accentColor,
                  ),
                  const Text('دری'),
                ],
              ),
            ),
            Flexible(
              child: Row(
                children: <Widget>[
                  Radio(
                    value: 'English',
                    groupValue: appLanguageOption,
                    onChanged: onChangeAppLanguage,
                    activeColor: Theme.of(context).accentColor,
                  ),
                  const Text('English'),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  renderLocationPicker(appLanguage) {
    Alert(
      context: context,
      title: appLanguage['locationHolder'],
      content: ChangeLocation(
        onChangeUserLocality: onChangeUserLocality,
        onChangeUserProvince: onChangeUserProvince,
      ),
      buttons: [
        DialogButton(
          onPressed: () {
            Navigator.pop(context);
            updateUserLocation(
              userLocality: locality,
              userProvince: province,
            );
          },
          child: Text(
            appLanguage['save'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
        DialogButton(
          color: Colors.grey[200],
          onPressed: () => Navigator.pop(context),
          child: Text(
            appLanguage['cancel'],
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
      ],
    ).show();
  }
}
