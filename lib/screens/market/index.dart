import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'advert.dart';
import '../../languages/provincesTranslator.dart';
import '../../providers/authProvider.dart';
import '../../providers/locationProvider.dart';
import '../../util/filterList.dart';
import '../../widgets/noContent.dart';
import '../../widgets/topScreenFilterOption.dart';
import '../../widgets/wait.dart';
import '../../providers/postsProvider.dart';
import '../../languages/index.dart';

class Market extends StatefulWidget {
  final searchBarString;
  final usersProvince;
  Market({
    Key key,
    this.searchBarString,
    this.usersProvince,
  }) : super(key: key);
  @override
  _MarketState createState() => _MarketState();
}

class _MarketState extends State<Market> {
  String currentFilterOption;
  int currentOptionId = 1;
  var appLanguage;
  String currentUserId;
  String userLocality;

  handleFilterOptionsChange(text, id) {
    setState(() {
      currentFilterOption = text;
      currentOptionId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentFilterOption == null &&
        currentUserId == null &&
        userLocality == null) {
      setState(() {
        userLocality = Provider.of<LocationProvider>(context, listen: false)
            .getUserLocality;
        appLanguage = getLanguages(context);
        currentUserId =
            Provider.of<AuthProvider>(context, listen: false).userId;
        currentFilterOption = userLocality;
      });
    }
    if (currentFilterOption == null) {
      setState(() {
        currentFilterOption = userLocality;
      });
    }
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: <Widget>[
          filterOptions(appLanguage, userLocality),
          StreamBuilder(
            stream: Provider.of<PostsProvider>(context).getAllPosts('adverts'),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return wait(appLanguage['wait'], context);
              }
              if (snapshot.data.documents.toList().length == 0) {
                return noContent(appLanguage['noContent'], context);
              }

              List<DocumentSnapshot> tempList = snapshot.data.documents;
              List<Map<dynamic, dynamic>> adverts = List();
              adverts = tempList.map((DocumentSnapshot docSnapshot) {
                var advert = {
                  'advert': docSnapshot.data,
                  'advertId': docSnapshot.documentID,
                };
                return advert;
              }).toList();

              var filteredPosts = filterList(
                posts: adverts,
                currentFilterOption: currentFilterOption,
                currentUserId: currentUserId,
                type: 'adverts',
                appLanguage: appLanguage,
                appBarSearchString: widget.searchBarString,
                context: context,
              );

              return filteredPosts.length > 0
                  ? GridView.builder(
                      itemCount: filteredPosts.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(
                        left: 3.0,
                        right: 3.0,
                        top: 0,
                        bottom: 0.0,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                      ),
                      itemBuilder: (context, index) {
                        final advertId =
                            filteredPosts.toList()[index]['advertId'];
                        var advert = filteredPosts.toList()[index]['advert'];
                        return Advert(
                          advert: advert,
                          advertId: advertId,
                          usersProvince: widget.usersProvince,
                        );
                      },
                    )
                  : noContent(appLanguage['noContent'], context);
            },
          ),
        ],
      ),
    );
  }

  Widget filterOptions(appLanguage, userLocation) {
    return SingleChildScrollView(
      child: Container(
        height: 40.0,
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 2.0),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            topScreenFilterOption(
              text: userLocation,
              id: 1,
              currentOptionId: currentOptionId,
              handleFilterOptionsChange: handleFilterOptionsChange,
            ),
            topScreenFilterOption(
              text: provincesTranslator[widget.usersProvince],
              id: 2,
              currentOptionId: currentOptionId,
              handleFilterOptionsChange: handleFilterOptionsChange,
            ),
            topScreenFilterOption(
              text: 'افغانستان',
              id: 3,
              currentOptionId: currentOptionId,
              handleFilterOptionsChange: handleFilterOptionsChange,
            ),
            topScreenFilterOption(
              text: appLanguage['myAdverts'],
              id: 4,
              currentOptionId: currentOptionId,
              handleFilterOptionsChange: handleFilterOptionsChange,
            ),
            topScreenFilterOption(
              text: appLanguage['sell'],
              id: 5,
              currentOptionId: currentOptionId,
              handleFilterOptionsChange: handleFilterOptionsChange,
            ),
            topScreenFilterOption(
              text: appLanguage['rent'],
              id: 6,
              currentOptionId: currentOptionId,
              handleFilterOptionsChange: handleFilterOptionsChange,
            ),
            topScreenFilterOption(
              text: appLanguage['buy'],
              id: 7,
              currentOptionId: currentOptionId,
              handleFilterOptionsChange: handleFilterOptionsChange,
            ),
            topScreenFilterOption(
              text: appLanguage['myFavorites'],
              id: 9,
              currentOptionId: currentOptionId,
              handleFilterOptionsChange: handleFilterOptionsChange,
            ),
          ],
        ),
      ),
    );
  }
}
