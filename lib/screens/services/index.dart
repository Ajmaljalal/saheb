import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:saheb/util/mapPostTypes.dart';
import '../../languages/index.dart';
import 'servicesList.dart';

class Services extends StatefulWidget {
  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  goToServicesListScreen(serviceType, appLanguage) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServicesList(
          serviceType: mapPostType(serviceType.toLowerCase(), appLanguage),
          serviceTypeString: serviceType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = getLanguages(context);

    return GridView.count(
      padding: const EdgeInsets.all(20.0),
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 7.0,
      crossAxisCount: 2,
      children: <Widget>[
        serviceCategory(
          appLanguage: appLanguage,
          color: Colors.blue[500],
          context: context,
          type: appLanguage['health'],
          icon: CachedNetworkImage(
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/saheb-mobile.appspot.com/o/icons%2Fpngs%2Fstethoscope.png?alt=media&token=39ca7a70-7b0d-4e7a-b51d-aedf5a99e7d1'),
        ),
        serviceCategory(
          appLanguage: appLanguage,
          color: Colors.deepOrange,
          context: context,
          type: appLanguage['education'],
          icon: CachedNetworkImage(
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/saheb-mobile.appspot.com/o/icons%2Fpngs%2Fopen-book.png?alt=media&token=882ebc8a-b2f3-4ba0-be84-216f3ebbb888'),
        ),
        serviceCategory(
          appLanguage: appLanguage,
          color: Colors.amber,
          context: context,
          type: appLanguage['computer'],
          icon: CachedNetworkImage(
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/saheb-mobile.appspot.com/o/icons%2Fpngs%2Fresponsive.png?alt=media&token=8a7fdb7d-1a6d-4f9f-bddb-6f3644061cf6'),
        ),
        serviceCategory(
          appLanguage: appLanguage,
          color: Colors.blueGrey,
          context: context,
          type: appLanguage['electrician'],
          icon: CachedNetworkImage(
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/saheb-mobile.appspot.com/o/icons%2Fpngs%2Fplug.png?alt=media&token=8ba90a26-445b-4548-a82b-9d41442f2310'),
        ),
        serviceCategory(
          appLanguage: appLanguage,
          color: Colors.green,
          context: context,
          type: appLanguage['painting'],
          icon: CachedNetworkImage(
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/saheb-mobile.appspot.com/o/icons%2Fpngs%2Fpaint-roller.png?alt=media&token=77eb9d17-1afa-4872-a6ed-879258dc44d1'),
        ),
        serviceCategory(
          appLanguage: appLanguage,
          color: Colors.cyan,
          context: context,
          type: appLanguage['construction'],
          icon: CachedNetworkImage(
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/saheb-mobile.appspot.com/o/icons%2Fpngs%2Fbrickwall.png?alt=media&token=b945ecef-1d82-4418-94ca-c8ee68422008'),
        ),
        serviceCategory(
          appLanguage: appLanguage,
          color: Colors.indigo,
          context: context,
          type: appLanguage['carpenter'],
          icon: CachedNetworkImage(
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/saheb-mobile.appspot.com/o/icons%2Fpngs%2Fcarpenter.png?alt=media&token=53d453f9-248d-48cf-b560-34de328a8382'),
        ),
        serviceCategory(
          appLanguage: appLanguage,
          color: Colors.deepPurpleAccent,
          context: context,
          type: appLanguage['mechanic'],
          icon: CachedNetworkImage(
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/saheb-mobile.appspot.com/o/icons%2Fpngs%2Fmechanic.png?alt=media&token=050e2373-c0e9-4471-a52a-927f70c7e5fa'),
        ),
        serviceCategory(
          appLanguage: appLanguage,
          color: Colors.blueAccent,
          context: context,
          type: appLanguage['laundry'],
          icon: CachedNetworkImage(
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/saheb-mobile.appspot.com/o/icons%2Fpngs%2Fironing.png?alt=media&token=81897962-5e2d-4795-b5cf-39b8ca6c768e'),
        ),
        serviceCategory(
          appLanguage: appLanguage,
          color: Colors.brown,
          context: context,
          type: appLanguage['transportation'],
          icon: CachedNetworkImage(
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/saheb-mobile.appspot.com/o/icons%2Fpngs%2Fdelivery.png?alt=media&token=8679e7ae-6547-4595-af44-91e44e2c8bac'),
        ),
        serviceCategory(
          appLanguage: appLanguage,
          color: Colors.yellow,
          context: context,
          type: appLanguage['cleaning'],
          icon: CachedNetworkImage(
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/saheb-mobile.appspot.com/o/icons%2Fpngs%2Fbroom.png?alt=media&token=c222d68e-fe7c-4c46-bea7-d20d7f41cfe5'),
        ),
        serviceCategory(
          appLanguage: appLanguage,
          color: Colors.black,
          context: context,
          type: appLanguage['legal'],
          icon: CachedNetworkImage(
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/saheb-mobile.appspot.com/o/icons%2Fpngs%2Flaw-book.png?alt=media&token=cbdf8369-77f0-450e-ae70-4984e41f0d99'),
        ),
        serviceCategory(
          appLanguage: appLanguage,
          color: Colors.black,
          context: context,
          type: appLanguage['plumber'],
          icon: CachedNetworkImage(
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/saheb-mobile.appspot.com/o/icons%2Fpngs%2Fplumber.png?alt=media&token=18bde9c0-0255-49ac-a5cc-982753b9a060'),
        ),
        serviceCategory(
          appLanguage: appLanguage,
          color: Colors.purpleAccent,
          context: context,
          type: appLanguage['decoration'],
          icon: CachedNetworkImage(
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/saheb-mobile.appspot.com/o/icons%2Fpngs%2Fballs.png?alt=media&token=177500da-4efa-4f01-8b0d-59316c54f4f0'),
        ),
        serviceCategory(
          appLanguage: appLanguage,
          color: Colors.blueAccent,
          context: context,
          type: appLanguage['cosmetics'],
          icon: CachedNetworkImage(
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/saheb-mobile.appspot.com/o/icons%2Fpngs%2Fhairdresser%20(1).png?alt=media&token=28bc60d7-4406-42da-bedc-72796f8510c6'),
        ),
      ],
    );
  }

  Widget serviceCategory({
    appLanguage,
    context,
    color,
    type,
    icon,
  }) {
    return GestureDetector(
      onTap: () {
        goToServicesListScreen(type, appLanguage);
      },
      child: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(height: 64.0, width: 64.0, child: icon),
              const SizedBox(
                height: 10.0,
              ),
              Center(
                child: Text(
                  type.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.cyanAccent,
            width: 0.2,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }
}
