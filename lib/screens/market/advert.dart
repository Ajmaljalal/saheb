import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:saheb/util/isRTL.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saheb/providers/postsProvider.dart';
import '../../providers/languageProvider.dart';
import '../../constants/constants.dart';
import '../../providers/authProvider.dart';
import 'advertDetails.dart';
import '../../mixins/post.dart';
import '../../mixins/advert.dart';
import '../../languages/index.dart';

class Advert extends StatefulWidget {
  final advert;
  final advertId;
  final usersProvince;
  Advert({Key key, this.advert, this.advertId, this.usersProvince})
      : super(key: key);

  @override
  _AdvertState createState() => _AdvertState();
}

class _AdvertState extends State<Advert> with PostMixin, AdvertMixin {
  bool revealMoreTextFlag = false;

  goToDetailsScreen(advertId, advertTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdvertDetails(
          advertTitle: advertTitle,
          advertId: advertId,
        ),
      ),
    );
  }

  deleteAdvert(context) {
    Provider.of<PostsProvider>(context).deleteOnePost(
      'adverts',
      widget.advert.documentID,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = getLanguages(context);
    final advert = widget.advert;
    final currentLanguage = Provider.of<LanguageProvider>(context).getLanguage;
    double fontSize = currentLanguage == 'English' ? 12.0 : 14.0;
    return GestureDetector(
      onTap: () {
        goToDetailsScreen(widget.advertId, advert['title']);
      },
      child: Container(
        margin: EdgeInsets.only(
          top: 5.0,
          left: 3.0,
          right: 3.0,
          bottom: 8.0,
        ),
        padding: EdgeInsets.only(bottom: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            10.0,
          ),
          border: Border.all(color: Colors.cyanAccent, width: 0.5),
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            advertImageHolder(advert['images']),
            Expanded(
              child: Container(
                width: 168.0,
                padding: EdgeInsets.symmetric(horizontal: 7.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    advertTitleHolder(advert['title'], fontSize),
                    advertPriceDateHolder(
                        advert['price'], advert['date'], appLanguage)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget advertTitleHolder(title, fontSize) {
    return Container(
      margin: EdgeInsets.only(top: 3.0),
      child: Text(
        title,
        maxLines: 2,
        textDirection: isRTL(title) ? TextDirection.rtl : TextDirection.ltr,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget advertPriceDateHolder(price, date, appLanguage) {
    final shamsiDate = Jalali.fromDateTime(date.toDate());
    final advertDate =
        '${shamsiDate.formatter.d.toString()}   ${shamsiDate.formatter.mN}';
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              30.0,
            ),
            color: Colors.purple,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 5.0,
            vertical: 2.0,
          ),
          child: Center(
            child: Text(
              price.toString() == 'null' ? appLanguage['noPrice'] : price,
              textDirection: isRTL(price.toString())
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        Container(
          child: Text(
            advertDate,
            textDirection: isRTL(advertDate.toString())
                ? TextDirection.rtl
                : TextDirection.ltr,
            style: TextStyle(
              fontSize: 10.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget advertImageHolder(images) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        10.0,
      ),
      child: images.length > 0
          ? Image.network(
              images[0],
              fit: BoxFit.cover,
              height: 150.0,
              width: 168.0,
            )
          : Center(
              child: Icon(
                FontAwesomeIcons.camera,
                color: Colors.grey[200],
                size: 120.0,
              ),
            ),
    );
  }
}
