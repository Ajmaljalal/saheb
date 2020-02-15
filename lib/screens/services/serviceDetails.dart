import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/postsProvider.dart';
import '../../screens/messages/chatScreen.dart';
import '../../util/isRTL.dart';
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
import '../../widgets/emptyBox.dart';
import '../../widgets/emptySpace.dart';
import '../../widgets/image_slider.dart';

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
  bool fastMessageSent = false;

  deletePost(context, message, images) async {
    setState(() {
      serviceDeleted = true;
    });
    Navigator.pop(context);
    Provider.of<PostsProvider>(context)
        .deleteOneRecord(widget.serviceId, 'ids_services', null);
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
    final currentUserId =
        Provider.of<AuthProvider>(context, listen: false).userId;
    final currentLanguage =
        Provider.of<LanguageProvider>(context, listen: false).getLanguage;
    double fontSize = currentLanguage == 'English' ? 13.5 : 16.0;

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
        serviceId: serviceId,
        serviceTitle: serviceTitle,
        appLanguage: appLanguage,
        userId: currentUserId,
        fontSize: fontSize,
      ),
    );
  }

  Widget _buildContent({
    serviceId,
    serviceTitle,
    appLanguage,
    userId,
    fontSize,
  }) {
    return serviceDeleted == false
        ? StreamBuilder(
            stream: Provider.of<PostsProvider>(context, listen: false)
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

              final shamsiDate = service != null
                  ? Jalali.fromDateTime(service['date'].toDate())
                  : null;
              final serviceDate =
                  '${shamsiDate.formatter.d.toString()}   ${shamsiDate.formatter.mN}';
              final serviceFirstImage =
                  service['images'].length > 0 ? service['images'][0] : 'null';
              return _buildServiceContent(
                context: context,
                service: service,
                fontSize: fontSize,
                serviceDate: serviceDate,
                isOwner: isOwner,
                appLanguage: appLanguage,
                userId: userId,
                serviceFirstImage: serviceFirstImage,
              );
            },
          )
        : wait(appLanguage['wait'], context);
  }

  Widget _buildServiceContent({
    BuildContext context,
    service,
    fontSize,
    String serviceDate,
    bool isOwner,
    appLanguage,
    userId,
    serviceFirstImage,
  }) {
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width * 1,
          minHeight: MediaQuery.of(context).size.height * 1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildServiceImages(service['images']),
            const EmptySpace(height: 5.0),
            _buildServiceTitle(
              title: service['title'],
              fontSize: fontSize,
            ),
            _buildServiceDateAndLocation(
              Icons.my_location,
              service['location'],
              serviceDate,
              service['fullAddress'],
            ),
            const EmptySpace(height: 15.0),
            _buildServiceOpenCloseState(
              isOwner: isOwner,
              open: service['open'],
              openText: appLanguage['openNow'],
              closeText: appLanguage['closeNow'],
              userId: userId,
              serviceType: service['type'],
            ),
            const EmptySpace(height: 15.0),
            isOwner
                ? _buildCallToActionButtonsForOwner(
                    context: context,
                    appLanguage: appLanguage,
                    onDelete: deletePost,
                    serviceImages: service['images'],
                  )
                : _buildCallToActionButtons(
                    context: context,
                    owner: service['owner'],
                    userId: userId,
                    appLanguage: appLanguage,
                    servicePhoto: serviceFirstImage,
                    isFavorite: service['favorites'].contains(userId),
                    phoneNumber: service['phone'],
                    onFavorite: favoriteAPost,
                  ),
            const EmptySpace(height: 10.0),
            horizontalDividerIndented(),
            _buildServiceDescription(
              appLanguage['serviceDescription'],
              service['desc'],
              fontSize,
            ),
            const EmptySpace(height: 5.0),
//            !isOwner
//                ? _buildServiceOwnerDetails(
//                    owner: service['owner'],
//                    appLanguage: appLanguage,
//                    fontSize: fontSize,
//                  )
//                : emptyBox(),
//            const EmptySpace(height: 10.0),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceImages(List<dynamic> images) {
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

  Widget _buildServiceTitle({
    title,
    fontSize,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        postTittleHolder(title.toString(), 20.0, context),
      ],
    );
  }

  Widget _buildServiceDateAndLocation(
    icon,
    serviceLocation,
    serviceDate,
    serviceFullAddress,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                serviceDate.toString(),
                textDirection:
                    isRTL(serviceDate) ? TextDirection.rtl : TextDirection.ltr,
              ),
              Text(' --  '),
              Text(
                serviceLocation.toString(),
                textDirection: isRTL(serviceLocation)
                    ? TextDirection.rtl
                    : TextDirection.ltr,
              ),
            ],
          ),
          serviceFullAddress != null
              ? Text(
                  serviceFullAddress,
                  textDirection: isRTL(serviceFullAddress)
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                )
              : emptyBox(),
        ],
      ),
    );
  }

  Widget _buildServiceOpenCloseState({
    isOwner,
    open,
    openText,
    closeText,
    userId,
    serviceType,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildToggleOpenCloseOptions(
          openCloseText: open ? openText : closeText,
          isOpen: open,
          isOwner: isOwner,
          openText: open ? openText : closeText,
          userId: userId,
          context: context,
          serviceType: serviceType,
        ),
      ],
    );
  }

  Widget _buildToggleOpenCloseOptions({
    openCloseText,
    isOpen,
    isOwner,
    openText,
    userId,
    context,
    serviceType,
  }) {
    if (isOwner) {
      return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: isOpen ? Colors.green : Colors.red),
            color: isOpen
                ? Colors.green.withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(openCloseText),
              Switch.adaptive(
                onChanged: (value) async {
                  await Provider.of<PostsProvider>(context, listen: false)
                      .toggleServiceOpenClose(
                    serviceId: widget.serviceId,
                    userId: userId,
                    openClose: value,
                  );
                },
                value: isOpen,
                activeTrackColor: Colors.purpleAccent,
                activeColor: Colors.purple,
              ),
            ],
          ));
    } else {
      return Container(
        height: 50.0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 5.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: isOpen ? Colors.green : Colors.red),
          color: isOpen
              ? Colors.green.withOpacity(0.1)
              : Colors.red.withOpacity(0.2),
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

  Widget _buildCallToActionButtons({
    context,
    owner,
    phoneNumber,
    appLanguage,
    servicePhoto,
    userId,
    isFavorite,
    onFavorite,
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
                    aboutId: widget.serviceId,
                    aboutTitle: widget.serviceTitle,
                    aboutPhotoUrl: servicePhoto,
                  ),
                ),
              );
            },
            iconSize: 16.0,
          ),
          CircledButton(
            icon: Icons.favorite,
            fillColor: isFavorite ? Colors.purple : Colors.grey[300],
            iconColor: isFavorite ? Colors.white : Colors.black,
            width: 35.0,
            height: 35.0,
            onPressed: () =>
                onFavorite(userId, appLanguage['serviceSaved'], isFavorite),
            iconSize: 16.0,
          ),
        ],
      ),
    );
  }

  Widget _buildCallToActionButtonsForOwner({
    context,
    appLanguage,
    onDelete,
    serviceImages,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircledButton(
            icon: Icons.edit,
            fillColor: Colors.grey[300],
            iconColor: Colors.green,
            width: 35.0,
            height: 35.0,
            onPressed: () => null,
            iconSize: 16.0,
          ),
          CircledButton(
            icon: Icons.delete,
            fillColor: Colors.grey[300],
            iconColor: Colors.red,
            width: 35.0,
            height: 35.0,
            onPressed: () =>
                onDelete(context, appLanguage['serviceDeleted'], serviceImages),
            iconSize: 16.0,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceDescription(
    titleText,
    serviceDesc,
    fontSize,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 5.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            titleText,
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            serviceDesc,
            textDirection:
                isRTL(serviceDesc) ? TextDirection.rtl : TextDirection.ltr,
            style: TextStyle(
              fontSize: fontSize,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

//  Widget _buildServiceOwnerDetails({
//    owner,
//    appLanguage,
//    fontSize,
//  }) {
//    return Container(
//      width: MediaQuery.of(context).size.width * 1,
//      margin: EdgeInsets.symmetric(
//        horizontal: 8.0,
//      ),
//      child: Card(
//        elevation: 4.0,
//        child: Container(
//          child: Row(
//            children: <Widget>[
//              userAvatarHolder(
//                url: owner['photo'],
//              ),
//              Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Text(
//                    owner['name'],
//                    style: TextStyle(
//                      color: Colors.black,
//                      fontSize: fontSize,
//                      fontWeight: FontWeight.bold,
//                    ),
//                  ),
//                  Text(
//                    owner['location'],
//                    style: TextStyle(
//                      color: Colors.black,
//                      fontSize: 12.0,
//                    ),
//                  ),
//                ],
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
}
