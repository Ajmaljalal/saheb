import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/postsProvider.dart';
import '../../screens/messages/chatScreen.dart';
import '../../util/isRTL.dart';
import '../../widgets/emptyBox.dart';
import '../../widgets/errorDialog.dart';
import '../../widgets/horizontalDividerIndented.dart';
import '../../widgets/noContent.dart';
import '../../widgets/wait.dart';
import '../../providers/authProvider.dart';
import '../../providers/languageProvider.dart';
import '../../mixins/post.dart';
import '../../mixins/advert.dart';
import '../../languages/index.dart';
import '../../widgets/fullScreenImage.dart';
import '../../widgets/showInfoFushbar.dart';

class ServiceDetails extends StatefulWidget {
  final serviceTitle;
  final serviceId;
  ServiceDetails({Key key, this.serviceId, this.serviceTitle})
      : super(key: key);
  @override
  _ServiceDetailsState createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails>
    with PostMixin, AdvertMixin {
  bool serviceDeleted = false;

  deletePost(context, message, images) async {
    setState(() {
      serviceDeleted = true;
    });
    Navigator.pop(context);
    renderFlashBar(message);
    await Provider.of<PostsProvider>(context).deleteOneRecord(
      widget.serviceId,
      'services',
      images,
    );
  }

  favoriteAPost(
    userId,
    message,
    isLiked,
  ) async {
    await Provider.of<PostsProvider>(context).favoriteAPost(
      widget.serviceId,
      'services',
      userId,
      isLiked,
    );
    if (!isLiked) {
      renderFlashBar(message);
    }
  }

  renderFlashBar(message) {
    showInfoFlushbar(
      context: context,
      duration: 2,
      message: message,
      icon: Icons.check_circle,
      progressBar: false,
      positionTop: false,
    );
  }

  callPhoneNumber(phoneNumber) async {
    if (await canLaunch("tel://${phoneNumber.toString()}")) {
      await launch(("tel://${phoneNumber.toString()}"));
    } else {
      throw 'Could not call $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = getLanguages(context);
    final String serviceTitle = widget.serviceTitle.toString();
    final String serviceId = widget.serviceId;
    final currentUserId = Provider.of<AuthProvider>(context).userId;
    final currentLanguage = Provider.of<LanguageProvider>(context).getLanguage;
    double fontSize = currentLanguage == 'English' ? 12.5 : 15.0;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(),
      ),
      body: renderServiceContent(
        serviceId: serviceId,
        serviceTitle: serviceTitle,
        appLanguage: appLanguage,
        userId: currentUserId,
        fontSize: fontSize,
      ),
    );
  }

  Widget renderServiceContent({
    serviceId,
    serviceTitle,
    appLanguage,
    userId,
    fontSize,
  }) {
    return serviceDeleted == false
        ? StreamBuilder(
            stream: Provider.of<PostsProvider>(context)
                .getOnePost('services', serviceId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return wait(appLanguage['wait'], context);
              }
              if (snapshot.hasError) {
                return noContent(appLanguage['noContent'], context);
              }
              final service = snapshot.data;
              final bool isOwner =
                  service['owner']['id'] == userId ? true : false;
              final serviceFirstImage =
                  service['images'].length > 0 ? service['images'][0] : 'null';
              return Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width * 1,
                              minHeight: MediaQuery.of(context).size.height * 1,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    serviceImagesHolder(service['images']),
                                    serviceMoreImageIndicator(
                                      appLanguage: appLanguage,
                                      length: service['images'].length - 1,
                                      context: context,
                                    ),
                                    serviceActionButtonsHolder(
                                        isOwner: isOwner,
                                        userId: userId,
                                        appLanguage: appLanguage,
                                        isLiked: service['favorites']
                                            .contains(userId),
                                        serviceImages: service['images']),
                                  ],
                                ),
                                const SizedBox(height: 5.0),
                                serviceTitleAndStatusHolder(
                                  title: service['title'],
                                  open: service['open'],
                                  isOwner: isOwner,
                                  fontSize: fontSize,
                                  openText: appLanguage['open'],
                                  closeText: appLanguage['close'],
                                  appLanguage: appLanguage,
                                  userId: userId,
                                ),
                                horizontalDividerIndented(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    serviceDetails(
                                      Icons.location_on,
                                      service['location'],
                                      false,
                                    ),
                                    serviceDetails(
                                      Icons.phone_iphone,
                                      service['phone'].toString(),
                                      false,
                                    ),
                                  ],
                                ),
                                serviceDetails(Icons.email,
                                    service['email'].toString(), false),
                                serviceDetails(
                                  Icons.my_location,
                                  service['fullAddress'].toString(),
                                  true,
                                ),
//                                Container(
//                                  width: MediaQuery.of(context).size.width * 1,
//                                  padding: const EdgeInsets.symmetric(
//                                    horizontal: 10.0,
//                                  ),
//                                  child: Text(
//                                    service['fullAddress'].toString(),
//                                    textDirection: isRTL(service['fullAddress'])
//                                        ? TextDirection.rtl
//                                        : TextDirection.ltr,
//                                    style: TextStyle(fontSize: fontSize),
//                                  ),
//                                ),
                                horizontalDividerIndented(),
                                Container(
                                  width: MediaQuery.of(context).size.width * 1,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  child: Text(
                                    service['desc'].toString(),
                                    textDirection: isRTL(service['desc'])
                                        ? TextDirection.rtl
                                        : TextDirection.ltr,
                                    style: TextStyle(fontSize: fontSize),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  !isOwner
                      ? Positioned(
                          bottom: 0.0,
                          right: 0,
                          left: 0,
                          child: serviceContactDetails(
                            service['phone'],
                            appLanguage,
                            fontSize,
                            service['owner']['id'],
                            service['owner']['name'],
                            service['owner']['photo'],
                            serviceFirstImage,
                          ),
                        )
                      : emptyBox(),
                ],
              );
            },
          )
        : wait(appLanguage['wait'], context);
  }

  Widget serviceImagesHolder(images) {
    return GestureDetector(
      onTap: () {
        if (images.length > 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullScreenImage(
                images: images,
              ),
            ),
          );
        } else {
          return;
        }
      },
      child: images.length > 0
          ? postImages(
              image: images[0],
              context: context,
              scrollView: Axis.horizontal,
            )
          : Center(
              child: Icon(
                FontAwesomeIcons.camera,
                color: Colors.grey[200],
                size: 140.0,
              ),
            ),
    );
  }

  Widget serviceMoreImageIndicator({
    appLanguage,
    length,
    context,
  }) {
    final userLanguage = Provider.of<LanguageProvider>(context).getLanguage;
    return length > 0
        ? Positioned(
            bottom: 6.0,
            right: userLanguage == 'English' ? 0.0 : 265.0,
            left: userLanguage == 'English' ? 265.0 : 0.0,
            child: Container(
              color: Colors.white.withOpacity(0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    FontAwesomeIcons.images,
                    size: 18.0,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    '+${length.toString()}',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ],
              ),
            ),
          )
        : emptyBox();
  }

  Widget serviceTitleAndStatusHolder({
    title,
    isOwner,
    open,
    fontSize,
    openText,
    closeText,
    appLanguage,
    userId,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: postTittleHolder(title.toString(), fontSize, context),
        ),
        openCloseOptions(
          openCloseText: open ? openText : closeText,
          isOpen: open,
          isOwner: isOwner,
          openText: open ? openText : closeText,
          userId: userId,
        ),
      ],
    );
  }

  Widget openCloseOptions({
    openCloseText,
    isOpen,
    isOwner,
    openText,
    userId,
  }) {
    if (isOwner) {
      return Container(
          height: 25.0,
          width: 100.0,
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Switch.adaptive(
                onChanged: (value) async {
                  await Provider.of<PostsProvider>(context)
                      .toggleServiceOpenClose(
                    serviceId: widget.serviceId,
                    userId: userId,
                    openClose: value,
                  );
                },
                value: isOpen,
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
              Text(openText)
            ],
          ));
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 5.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35.0),
          border: Border.all(color: Colors.purple),
        ),
        child: Center(
          child: Text(
            openCloseText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15.0,
              height: 0.9,
            ),
          ),
        ),
      );
    }
  }

  Widget serviceDetails(
    icon,
    text,
    isFullAddress,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            icon,
            size: 15.0,
            color: Colors.purple,
          ),
          const SizedBox(
            width: 5.0,
          ),
          text.toString() != 'null'
              ? Container(
                  width: isFullAddress
                      ? MediaQuery.of(context).size.width * 0.87
                      : null,
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 13.0,
                    ),
                  ),
                )
              : const Text('---'),
        ],
      ),
    );
  }

  Widget serviceContactDetails(
    phoneNumber,
    appLanguage,
    fontSize,
    serviceOwnerId,
    serviceOwnerName,
    serviceOwnerPhoto,
    servicePhoto,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 70.0),
      decoration: BoxDecoration(
        border: const Border(
          top: const BorderSide(
            color: Colors.cyanAccent,
            width: 0.5,
          ),
        ),
        color: Colors.grey[100],
      ),
      height: MediaQuery.of(context).size.height * 0.091,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
              child: const Icon(
                Entypo.message,
                size: 38.0,
                color: Colors.purple,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      messageId: null,
                      initiatorId: serviceOwnerId,
                      initiatorName: serviceOwnerName,
                      initiatorPhoto: serviceOwnerPhoto,
                      aboutId: widget.serviceId,
                      aboutTitle: widget.serviceTitle,
                      aboutPhotoUrl: servicePhoto,
                    ),
                  ),
                );
              },
            ),
            InkWell(
              child: const Icon(
                FontAwesome.phone_square,
                size: 30.0,
                color: Colors.purple,
              ),
              onTap: () {
                if (phoneNumber != 'null') {
                  callPhoneNumber(phoneNumber);
                } else
                  showErrorDialog(
                    appLanguage['noPhoneNumberProvide'],
                    context,
                    appLanguage['alertDialogTitle'],
                    appLanguage['ok'],
                  );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget serviceActionButtonsHolder({
    isOwner,
    userId,
    appLanguage,
    isLiked,
    serviceImages,
  }) {
    return Positioned(
      bottom: 0.0,
      right: 0,
      left: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          !isOwner
              ? serviceActionButton(
                  FontAwesomeIcons.heart,
                  Colors.white,
                  null,
                  favoriteAPost,
                  context,
                  'favorite',
                  userId,
                  appLanguage['serviceSaved'],
                  isLiked,
                  null,
                )
              : emptyBox(),
          isOwner
              ? serviceActionButton(
                  FontAwesomeIcons.trash,
                  Colors.red,
                  deletePost,
                  null,
                  context,
                  'delete',
                  userId,
                  appLanguage['serviceDeleted'],
                  isLiked,
                  serviceImages,
                )
              : emptyBox(),
        ],
      ),
    );
  }

  Widget serviceActionButton(
    icon,
    iconColor,
    onDelete,
    onFavorite,
    context,
    actionType,
    userId,
    message,
    isLiked,
    serviceImages,
  ) {
    return RawMaterialButton(
      constraints: const BoxConstraints(minWidth: 40.0, minHeight: 36.0),
      onPressed: () {
        if (actionType == 'delete') {
          onDelete(context, message, serviceImages);
        } else
          onFavorite(userId, message, isLiked);
      },
      child: Icon(
        icon,
        color: iconColor,
        size: 18.0,
      ),
      shape: const CircleBorder(),
      elevation: 2.0,
      fillColor: isLiked
          ? Colors.purple
          : actionType == 'delete' ? Colors.white : Colors.grey,
    );
  }
}
