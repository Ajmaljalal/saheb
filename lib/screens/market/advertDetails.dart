import 'package:com.pywast.pywast/providers/locationProvider.dart';
import 'package:com.pywast.pywast/util/uuid.dart';
import 'package:com.pywast.pywast/widgets/button.dart';
import 'package:com.pywast.pywast/widgets/emptyBox.dart';
import 'package:com.pywast.pywast/widgets/emptySpace.dart';
import 'package:com.pywast.pywast/widgets/image_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/postsProvider.dart';
import '../../screens/messages/chatScreen.dart';
import '../../util/isRTL.dart';
//import '../../widgets/emptyBox.dart';
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
import '../../util/close_screen.dart';
import '../../widgets/circled_button.dart';

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
  bool fastMessageSent = false;

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

  onSendFastMessage(text, owner, advertPhoto) async {
    if (text == null || text.length == 0) {
      return;
    }
    final initiator = {
      'id': owner['id'],
      'name': owner['name'],
      'photo': owner['photo'],
    };
    final aboutWhat = {
      'id': widget.advertId,
      'title': widget.advertTitle,
      'photoUrl': advertPhoto
    };
    final user = await Provider.of<AuthProvider>(context).currentUser;
    final newMessageId = Uuid().generateV4();
    final currentUserId =
        Provider.of<AuthProvider>(context, listen: false).userId;
    final userLocality =
        Provider.of<LocationProvider>(context, listen: false).getUserLocality;
    await Provider.of<PostsProvider>(context, listen: false)
        .startNewConversation(
      ownerName: user.displayName,
      ownerLocation: userLocality,
      ownerPhoto: user.photoUrl,
      userId: currentUserId,
      messageReceiverUserId: owner['id'],
      messageId: newMessageId,
      text: text,
      initiator: initiator,
      aboutWhat: aboutWhat,
    );
    setState(() {
      fastMessageSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = getLanguages(context);
    final String advertTitle = widget.advertTitle.toString();
    final String advertId = widget.advertId;
    final currentUserId =
        Provider.of<AuthProvider>(context, listen: false).userId;
    final currentLanguage =
        Provider.of<LanguageProvider>(context, listen: false).getLanguage;
    double fontSize = currentLanguage == 'English' ? 12.5 : 15.0;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(35.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          titleSpacing: 0.0,
          centerTitle: false,
          title: CircledButton(
            icon: Icons.close,
            fillColor: Colors.white,
            iconColor: Colors.purple,
            width: 25.0,
            height: 25.0,
            onPressed: () => closeScreen(context),
            iconSize: 18.0,
          ),
        ),
      ),
      body: _buildContent(
        advertId: advertId,
        advertTitle: advertTitle,
        appLanguage: appLanguage,
        userId: currentUserId,
        fontSize: fontSize,
      ),
    );
  }

  Widget _buildContent({
    advertId,
    advertTitle,
    appLanguage,
    userId,
    fontSize,
  }) {
    return advertDeleted == false
        ? StreamBuilder(
            stream: Provider.of<PostsProvider>(context, listen: false)
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
              return SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width * 1,
                    minHeight: MediaQuery.of(context).size.height * 1,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          _buildAdvertImages(advert['images']),
                        ],
                      ),
                      const EmptySpace(height: 5.0),
                      _buildTitleAndPriceHolder(
                        title: advert['title'],
                        price: advert['price'],
                        fontSize: fontSize,
                        noPrice: appLanguage['noPrice'],
                      ),
                      _buildAdvertDateAndLocation(
                        Icons.my_location,
                        advert['location'],
                        advertDate,
                      ),
                      !fastMessageSent
                          ? _buildSendInitialMessage(
                              context: context,
                              appLanguage: appLanguage,
                              owner: advert['owner'],
                              advertPhoto: advertFirstImage,
                            )
                          : _buildMessageSentDialog(
                              appLanguage['messageSent'],
                            ),
                      _buildCallToActionButtons(
                          context: context,
                          owner: advert['owner'],
                          userId: userId,
                          appLanguage: appLanguage,
                          advertPhoto: advertFirstImage,
                          isFavorite: advert['favorites'].contains(userId),
                          isOwner: isOwner,
                          phoneNumber: advert['phone'],
                          fontSize: fontSize,
                          onFavorite: favoriteAPost,
                          onDelete: deletePost,
                          advertImages: advert['images']),
                      const EmptySpace(height: 10.0),
                      horizontalDividerIndented(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 5.0,
                        ),
                        child: Text(
                          advert['text'].toString(),
                          textDirection: isRTL(advert['text'])
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          style: TextStyle(
                            fontSize: fontSize,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        : wait(appLanguage['wait'], context);
  }

  Widget _buildAdvertImages(List<dynamic> images) {
    List<String> postImages = images.cast<String>();
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
          ? ImageSlider(
              imageUrls: postImages,
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

  Widget _buildAdvertDateAndLocation(
    icon,
    advertLocation,
    advertDate,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(advertDate.toString()),
          Text(' --  '),
          Text(advertLocation.toString()),
        ],
      ),
    );
  }

  Widget _buildSendInitialMessage({
    context,
    appLanguage,
    owner,
    advertPhoto,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width * 0.95,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  appLanguage['sendFastMessage'],
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 12.0,
                  ),
                ),
              ),
              const EmptySpace(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildSendMessageInputField(appLanguage['stillAvailable']),
                  customButton(
                    appLanguage: appLanguage,
                    context: context,
                    onClick: () => onSendFastMessage(
                      appLanguage['stillAvailable'],
                      owner,
                      advertPhoto,
                    ),
                    forText: 'send',
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: 28.0,
                    fontSize: 12.0,
                  ),
                ],
              ),
            ],
          ),
        ),
        elevation: 4.0,
      ),
    );
  }

  _buildMessageSentDialog(dialogMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          dialogMessage,
          style: TextStyle(
            color: Colors.purple,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildSendMessageInputField(String stillAvailable) {
    return Container(
      height: 30.0,
      width: 205.0,
      child: TextFormField(
        initialValue: stillAvailable,
        autocorrect: false,
        cursorColor: Colors.black,
        style: TextStyle(
          color: Colors.black,
          fontSize: 12.0,
          height: .9,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          errorStyle: TextStyle(
            color: Colors.white,
            fontSize: 15.0,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Colors.transparent,
              width: 0.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Colors.transparent,
              width: 0.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCallToActionButtons({
    context,
    owner,
    phoneNumber,
    appLanguage,
    fontSize,
    advertPhoto,
    isOwner,
    userId,
    isFavorite,
    onFavorite,
    onDelete,
    advertImages,
  }) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CircledButton(
            icon: Icons.call,
            fillColor: Colors.grey[300],
            iconColor: Colors.black,
            width: 35.0,
            height: 35.0,
            onPressed: () {
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
            iconSize: 16.0,
          ),
          CircledButton(
            icon: Icons.message,
            fillColor: Colors.grey[300],
            iconColor: Colors.black,
            width: 35.0,
            height: 35.0,
            onPressed: () {
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
            iconSize: 16.0,
          ),
          !isOwner
              ? CircledButton(
                  icon: Icons.favorite,
                  fillColor: isFavorite ? Colors.purple : Colors.grey[300],
                  iconColor: isFavorite ? Colors.white : Colors.black,
                  width: 35.0,
                  height: 35.0,
                  onPressed: () => onFavorite(
                      userId, appLanguage['advertSaved'], isFavorite),
                  iconSize: 16.0,
                )
              : CircledButton(
                  icon: Icons.delete,
                  fillColor: Colors.grey[300],
                  iconColor: Colors.black,
                  width: 35.0,
                  height: 35.0,
                  onPressed: () => onDelete(
                      context, appLanguage['advertDeleted'], advertImages),
                  iconSize: 16.0,
                ),
        ],
      ),
    );
  }

  Widget _buildTitleAndPriceHolder({
    title,
    price,
    fontSize,
    noPrice,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        postTittleHolder(title.toString(), 20.0, context),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            price.toString() != null ? price : noPrice,
            style: TextStyle(
              color: Colors.cyan,
              fontSize: price.toString() != 'null' ? 17.0 : 15.0,
              letterSpacing: 3,
            ),
          ),
        ),
      ],
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
}
