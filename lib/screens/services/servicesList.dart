import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../languages/provincesTranslator.dart';
import '../../providers/authProvider.dart';
import '../../providers/locationProvider.dart';
import '../../providers/postsProvider.dart';
import '../../screens/services/serviceDetails.dart';
import '../../util/filterList.dart';
import '../../widgets/emptyBox.dart';
import '../../widgets/noContent.dart';
import '../../widgets/topScreenFilterOption.dart';
import '../../widgets/wait.dart';
import '../../languages/index.dart';

class ServicesList extends StatefulWidget {
  final serviceType;
  final serviceTypeString;
  ServicesList({
    this.serviceType,
    this.serviceTypeString,
  });
  @override
  _ServicesListState createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  String currentFilterOption;
  int currentOptionId = 1;
  String searchBarString;

  handleFilterOptionsChange(text, id) {
    setState(() {
      currentFilterOption = text;
      currentOptionId = id;
    });
  }

  goToServicesDetailsScreen(serviceId, serviceTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceDetails(
          serviceId: serviceId,
          serviceTitle: serviceTitle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = getLanguages(context);
    final currentUserId = Provider.of<AuthProvider>(context).userId;
    final userProvince = Provider.of<LocationProvider>(context).getUserProvince;
    final userLocality = Provider.of<LocationProvider>(context).getUserLocality;

    if (currentFilterOption == null) {
      setState(() {
        currentFilterOption = userLocality;
      });
    }
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          title: Text(widget.serviceTypeString),
        ),
      ),
      body: screenContent(
        appLanguage,
        currentUserId,
        userLocality,
        userProvince,
      ),
    );
  }

  Widget screenContent(
    appLanguage,
    currentUserId,
    userLocation,
    userProvince,
  ) {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: <Widget>[
          filterOptions(appLanguage, userLocation, userProvince),
          StreamBuilder(
            stream: Provider.of<PostsProvider>(context)
                .getAllServices(widget.serviceType),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return wait(appLanguage['wait'], context);
              }
              if (snapshot.data.documents.toList().length == 0) {
                return noContent(appLanguage['noContent'], context);
              }

              List<DocumentSnapshot> tempList = snapshot.data.documents;
              List<Map<dynamic, dynamic>> services = List();
              services = tempList.map((DocumentSnapshot docSnapshot) {
                var service = {
                  'post': docSnapshot.data,
                  'postId': docSnapshot.documentID,
                };
                return service;
              }).toList();

              var filteredPosts = filterList(
                posts: services,
                currentFilterOption: currentFilterOption,
                currentUserId: currentUserId,
                type: 'services',
                appLanguage: appLanguage,
                appBarSearchString: searchBarString,
              );
              return filteredPosts.length > 0
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filteredPosts.length,
                      itemBuilder: (context, index) {
                        final serviceId =
                            filteredPosts.toList()[index]['postId'];
                        var service = filteredPosts.toList()[index]['post'];
                        return serviceItem(
                          appLanguage: appLanguage,
                          service: service,
                          serviceId: serviceId,
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

  Widget filterOptions(
    appLanguage,
    userLocation,
    userProvince,
  ) {
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
              text: provincesTranslator[userProvince],
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
              text: appLanguage['myServices'],
              id: 4,
              currentOptionId: currentOptionId,
              handleFilterOptionsChange: handleFilterOptionsChange,
            ),
            topScreenFilterOption(
              text: appLanguage['myFavorites'],
              id: 5,
              currentOptionId: currentOptionId,
              handleFilterOptionsChange: handleFilterOptionsChange,
            ),
          ],
        ),
      ),
    );
  }

  Widget serviceItem({
    appLanguage,
    service,
    serviceId,
  }) {
    return GestureDetector(
      onTap: () {
        goToServicesDetailsScreen(serviceId, service['title']);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 5, left: 5.0, right: 5.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.cyanAccent,
            width: 0.2,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                serviceTitleHolder(service['title']),
                const SizedBox(
                  height: 15.0,
                ),
                serviceDetailsHolder(
                  firstOption: service['open']
                      ? appLanguage['open']
                      : appLanguage['close'],
                  firstIcon: service['open'] ? Icons.check_circle : Icons.close,
                  secondOption: null,
                  secondIcon: null,
                ),
                serviceDetailsHolder(
                  firstOption: service['location'],
                  secondOption: null,
                  firstIcon: Icons.location_on,
                  secondIcon: null,
                ),
              ],
            ),
            serviceImageHolder(service['images']),
          ],
        ),
      ),
    );
  }

  Widget serviceTitleHolder(title) {
    return Container(
      width: 192.0,
      child: Text(
        title,
        maxLines: 2,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.cyan,
          fontFamily: 'Muna',
        ),
      ),
    );
  }

  Widget serviceDetailsHolder({
    firstOption,
    secondOption,
    firstIcon,
    secondIcon,
  }) {
    return Container(
      width: 170.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                firstIcon,
                size: 15.0,
                color: Colors.purple,
              ),
              const SizedBox(width: 5.0),
              Text(firstOption),
            ],
          ),
          secondOption != null
              ? Row(
                  children: <Widget>[
                    Icon(
                      secondIcon,
                      size: 15.0,
                      color: Colors.purple,
                    ),
                    const SizedBox(width: 5.0),
                    Text(secondOption),
                  ],
                )
              : emptyBox(),
        ],
      ),
    );
  }

  Widget serviceImageHolder(images) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        5.0,
      ),
      child: images.length > 0
          ? Image.network(
              images[0],
              fit: BoxFit.cover,
              height: 100.0,
              width: 100.0,
            )
          : Center(
              child: Icon(
                FontAwesomeIcons.camera,
                color: Colors.grey[200],
                size: 100.0,
              ),
            ),
    );
  }
}
