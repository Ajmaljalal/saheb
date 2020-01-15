import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shamsi_date/shamsi_date.dart';
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

class AdvertDetails extends StatefulWidget {
  final advertTitle;
  final advertId;
  AdvertDetails({
    Key key,
    this.advertId,
    this.advertTitle,
  }) : super(key: key);
  @override
  _AdvertDetailsState createState() => _AdvertDetailsState();
}

class _AdvertDetailsState extends State<AdvertDetails>
    with PostMixin, AdvertMixin {
  bool advertDeleted = false;

  deletePost(context, message, images) async {
    setState(() {
      advertDeleted = true;
    });
    Navigator.pop(context);
    renderFlashBar(message);
    await Provider.of<PostsProvider>(context)
        .deleteOneRecord(widget.advertId, 'adverts', images);
  }

  favoriteAPost(userId, message, isFavorite) async {
    await Provider.of<PostsProvider>(context).favoriteAPost(
      widget.advertId,
      'adverts',
      userId,
      isFavorite,
    );
    if (!isFavorite) {
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
    final String advertTitle = widget.advertTitle.toString();
    final String advertId = widget.advertId;
    final currentUserId = Provider.of<AuthProvider>(context).userId;
    final currentLanguage = Provider.of<LanguageProvider>(context).getLanguage;
    double fontSize = currentLanguage == 'English' ? 12.5 : 15.0;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(),
      ),
      body: renderAdvertContent(
        advertId: advertId,
        advertTitle: advertTitle,
        appLanguage: appLanguage,
        userId: currentUserId,
        fontSize: fontSize,
      ),
    );
  }

  Widget renderAdvertContent({
    advertId,
    advertTitle,
    appLanguage,
    userId,
    fontSize,
  }) {
    return advertDeleted == false
        ? StreamBuilder(
            stream: Provider.of<PostsProvider>(context)
                .getOnePost('adverts', advertId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return wait(appLanguage['wait'], context);
              }
              if (snapshot.hasError) {
                return noContent(appLanguage['noContent'], context);
              }
              final advert = snapshot.data;
              final bool isOwner =
                  advert['owner']['id'] == userId ? true : false;

              final shamsiDate = advert != null
                  ? Jalali.fromDateTime(advert['date'].toDate())
                  : null;
              final advertDate =
                  '${shamsiDate.formatter.d.toString()}   ${shamsiDate.formatter.mN}';
              final advertFirstImage =
                  advert['images'].length > 0 ? advert['images'][0] : 'null';
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
                                    advertImagesHolder(advert['images']),
                                    advertMoreImageIndicator(
                                      appLanguage: appLanguage,
                                      length: (advert['images'].length) - 1,
                                      context: context,
                                    ),
                                    advertActionButtonsHolder(
                                      isOwner: isOwner,
                                      userId: userId,
                                      appLanguage: appLanguage,
                                      isFavorite:
                                          advert['favorites'].contains(userId),
                                      advertImages: advert['images'],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5.0),
                                advertTitleAndPriceHolder(
                                  title: advert['title'],
                                  price: advert['price'],
                                  fontSize: fontSize,
                                  noPrice: appLanguage['noPrice'],
                                ),
                                horizontalDividerIndented(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    advertDetails(
                                      appLanguage['locationHolder'],
                                      advert['location'],
                                    ),
                                    advertDetails(
                                      appLanguage['typeOfDeal'],
                                      advert['type'],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    advertDetails(
                                      appLanguage['phoneNumber'],
                                      advert['phone'].toString(),
                                    ),
                                    advertDetails(
                                        appLanguage['date'], advertDate),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    advertDetails(
                                      appLanguage['emailLabel'],
                                      advert['email'].toString(),
                                    ),
                                  ],
                                ),
                                horizontalDividerIndented(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  child: Text(
                                    advert['text'].toString(),
                                    textDirection: isRTL(advert['text'])
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
                          child: advertOwnersDetails(
                            advert['owner'],
                            advert['phone'],
                            appLanguage,
                            fontSize,
                            advertFirstImage,
                          ),
                        )
                      : emptyBox(),
                ],
              );
            },
          )
        : wait(appLanguage['wait'], context);
  }

  Widget advertImagesHolder(images) {
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

  Widget advertMoreImageIndicator({
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

  Widget advertTitleAndPriceHolder({
    title,
    price,
    fontSize,
    noPrice,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: postTittleHolder(title.toString(), fontSize, context),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            price.toString() != 'null' ? price : noPrice,
            style: TextStyle(
              color: Colors.cyan,
              fontSize: price.toString() != 'null' ? 17.0 : 15.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget advertDetails(
    forText,
    text,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '$forText: ',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                ),
              ),
              text.toString() != 'null' ? Text(text) : const Text('---'),
            ],
          ),
        ],
      ),
    );
  }

  Widget advertOwnersDetails(
    owner,
    phoneNumber,
    appLanguage,
    fontSize,
    advertPhoto,
  ) {
    return Container(
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              userAvatarHolder(
                url: owner['photo'],
              ),
              Text(
                owner['name'],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
          Container(
            width: 110.0,
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
                          initiatorId: owner['id'],
                          initiatorName: owner['name'],
                          initiatorPhoto: owner['photo'],
                          aboutId: widget.advertId,
                          aboutTitle: widget.advertTitle,
                          aboutPhotoUrl: advertPhoto,
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
                    if (phoneNumber != null) {
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
          )
        ],
      ),
    );
  }

  Widget advertActionButtonsHolder({
    isOwner,
    userId,
    appLanguage,
    isFavorite,
    advertImages,
  }) {
    return Positioned(
      bottom: 0.0,
      right: 0,
      left: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          !isOwner
              ? advertActionButton(
                  FontAwesomeIcons.heart,
                  Colors.white,
                  null,
                  favoriteAPost,
                  context,
                  'favorite',
                  userId,
                  appLanguage['advertSaved'],
                  isFavorite,
                  null,
                )
              : emptyBox(),
          isOwner
              ? advertActionButton(
                  FontAwesomeIcons.trash,
                  Colors.red,
                  deletePost,
                  null,
                  context,
                  'delete',
                  userId,
                  appLanguage['advertDeleted'],
                  isFavorite,
                  advertImages,
                )
              : emptyBox(),
        ],
      ),
    );
  }

  Widget advertActionButton(
    icon,
    iconColor,
    onDelete,
    onFavorite,
    context,
    actionType,
    userId,
    message,
    isFavorite,
    advertImages,
  ) {
    return RawMaterialButton(
      constraints: const BoxConstraints(
        minWidth: 40.0,
        minHeight: 36.0,
      ),
      onPressed: () {
        if (actionType == 'delete') {
          onDelete(context, message, advertImages);
        } else
          onFavorite(userId, message, isFavorite);
      },
      child: Icon(
        icon,
        color: iconColor,
        size: 18.0,
      ),
      shape: const CircleBorder(),
      elevation: 2.0,
      fillColor: isFavorite
          ? Colors.purple
          : actionType == 'delete' ? Colors.white : Colors.grey,
    );
  }
}
