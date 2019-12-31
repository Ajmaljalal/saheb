import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../languages/index.dart';
import '../../locations/locations_sublocations.dart';
import '../../providers/locationProvider.dart';
import '../../widgets/locationPicker.dart';
import '../../locations/provincesList.dart';

class ChangeLocation extends StatefulWidget {
  final onChangeUserLocality;
  final onChangeUserProvince;
  ChangeLocation({
    this.onChangeUserProvince,
    this.onChangeUserLocality,
  });
  @override
  _ChangeLocationState createState() => _ChangeLocationState();
}

class _ChangeLocationState extends State<ChangeLocation> {
  String selectedProvince;
  onProvinceChange(value) {
    widget.onChangeUserProvince(value);
    setState(() {
      selectedProvince = value;
    });
  }

  onLocalityChange(value) {
    widget.onChangeUserLocality(value);
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = getLanguages(context);
    final userLocality = Provider.of<LocationProvider>(context).getUserLocality;
    final userProvince = Provider.of<LocationProvider>(context).getUserProvince;

    return Container(
      child: Column(
        children: <Widget>[
          DropDownPicker(
            onChange: onProvinceChange,
            value:
                userProvince != null ? userProvince : appLanguage['province'],
            items: provincesList,
            hintText: appLanguage['search'],
            label: appLanguage['province'],
            search: true,
          ),
          DropDownPicker(
            onChange: onLocalityChange,
            value:
                userLocality != null ? userLocality : appLanguage['locality'],
            items: selectedProvince != null
                ? locations[selectedProvince]
                : locations[userProvince],
            hintText: appLanguage['search'],
            label: appLanguage['locality'],
            search: true,
          ),
        ],
      ),
    );
  }
}
