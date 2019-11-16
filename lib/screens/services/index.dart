import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../languages/index.dart';
import '../../widgets/errorDialog.dart';

class Services extends StatefulWidget {
  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  @override
  Widget build(BuildContext context) {
    final appLanguage = getLanguages(context);

    return GridView.count(
//      primary: false,
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
          icon: FontAwesomeIcons.hospital,
        ),
        serviceCategory(
          appLanguage: appLanguage,
          color: Colors.deepOrange,
          context: context,
          type: appLanguage['education'],
          icon: Icons.library_books,
        ),
        serviceCategory(
          appLanguage: appLanguage,
          color: Colors.amber,
          context: context,
          type: appLanguage['computer'],
          icon: FontAwesomeIcons.mobileAlt,
        ),
        serviceCategory(
          appLanguage: appLanguage,
          color: Colors.blueGrey,
          context: context,
          type: appLanguage['electrician'],
          icon: FontAwesomeIcons.carBattery,
        ),
        serviceCategory(
          appLanguage: appLanguage,
          color: Colors.green,
          context: context,
          type: appLanguage['painting'],
          icon: FontAwesomeIcons.paintRoller,
        ),
        serviceCategory(
          appLanguage: appLanguage,
          color: Colors.cyan,
          context: context,
          type: appLanguage['construction'],
          icon: FontAwesomeIcons.building,
        ),
        serviceCategory(
          appLanguage: appLanguage,
          color: Colors.indigo,
          context: context,
          type: appLanguage['carpenter'],
          icon: FontAwesomeIcons.toolbox,
        ),
        serviceCategory(
          appLanguage: appLanguage,
          color: Colors.deepPurpleAccent,
          context: context,
          type: appLanguage['mechanic'],
          icon: FontAwesomeIcons.carCrash,
        ),
        serviceCategory(
          appLanguage: appLanguage,
          color: Colors.blueAccent,
          context: context,
          type: appLanguage['laundry'],
          icon: FontAwesomeIcons.water,
        ),
        serviceCategory(
          appLanguage: appLanguage,
          color: Colors.brown,
          context: context,
          type: appLanguage['transportation'],
          icon: FontAwesomeIcons.car,
        ),
        serviceCategory(
          appLanguage: appLanguage,
          color: Colors.yellow,
          context: context,
          type: appLanguage['cleaning'],
          icon: Icons.format_clear,
        ),
        serviceCategory(
          appLanguage: appLanguage,
          color: Colors.black,
          context: context,
          type: appLanguage['legal'],
          icon: FontAwesomeIcons.newspaper,
        ),
        serviceCategory(
          appLanguage: appLanguage,
          color: Colors.purpleAccent,
          context: context,
          type: appLanguage['decoration'],
          icon: FontAwesomeIcons.borderStyle,
        ),
        serviceCategory(
          appLanguage: appLanguage,
          color: Colors.blueAccent,
          context: context,
          type: appLanguage['cosmetics'],
          icon: FontAwesomeIcons.cut,
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
        showErrorDialog(
          appLanguage['underConstruction'],
          context,
          appLanguage['alertDialogTitle'],
          appLanguage['ok'],
        );
      },
      child: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Icon(
                  icon,
                  color: color,
                  size: 35.0,
                ),
              ),
              const SizedBox(
                height: 25.0,
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
        padding: const EdgeInsets.symmetric(vertical: 25.0),
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
