filterListBasedOnLocation({posts, currentFilterOption, currentUserId}) {
  var filteredPosts = posts;

  if (currentFilterOption.toLowerCase() == 'افغانستان') {
    return filteredPosts;
  }

  filteredPosts = filteredPosts
      .where(
        (post) => post['location'].toString().toLowerCase().contains(
              currentFilterOption.toLowerCase(),
            ),
      )
      .toList();
  return filteredPosts;
}

filterList({
  List posts,
  appBarSearchString,
  String currentFilterOption,
  appLanguage,
  currentUserId,
  type,
  context,
}) {
  ///////////////// for adverts only ////////////////////////
  if (type == 'adverts') {
    var filteredPosts = posts;
    if (appBarSearchString != null) {
      filteredPosts = posts
          .where(
            (post) =>
                post['advert']['title']
                    .toString()
                    .contains(appBarSearchString.toString()) ||
                post['advert']['text']
                    .toString()
                    .contains(appBarSearchString.toString()) ||
                post['advert']['type']
                    .toString()
                    .contains(appBarSearchString.toString()),
          )
          .toList();
    }
    if (currentFilterOption.toLowerCase() == 'افغانستان') {
      return filteredPosts;
    }

    if (currentFilterOption == appLanguage['myAdverts']) {
      filteredPosts = filteredPosts
          .where(
            (post) =>
                post['advert']['owner']['id'].toString() ==
                    currentUserId.toString() &&
                (post['advert']['hiddenFrom']
                        .toList()
                        .contains(currentUserId.toString())) ==
                    false,
          )
          .toList();
      return filteredPosts;
    }

    if (currentFilterOption == appLanguage['myFavorites']) {
      filteredPosts = filteredPosts
          .where(
            (post) =>
                post['advert']['favorites']
                    .toList()
                    .contains(currentUserId.toString()) &&
                (post['advert']['hiddenFrom']
                        .toList()
                        .contains(currentUserId.toString())) ==
                    false,
          )
          .toList();
      return filteredPosts;
    }

    const String sellString = 'پلورل فروشی for sell';
    const String buyString = 'اخیستل خرید for purchase';
    const String rentString = 'کرایی for rent';

    if (sellString.contains(currentFilterOption.toLowerCase())) {
      filteredPosts = filteredPosts
          .where(
            (post) =>
                (sellString.contains(
                    post['advert']['type'].toString().toLowerCase())) &&
                (post['advert']['hiddenFrom']
                        .toList()
                        .contains(currentUserId.toLowerCase())) ==
                    false,
          )
          .toList();
      return filteredPosts;
    }

    if (buyString.contains(currentFilterOption.toLowerCase())) {
      filteredPosts = filteredPosts
          .where(
            (post) =>
                (buyString.contains(
                    post['advert']['type'].toString().toLowerCase())) &&
                (post['advert']['hiddenFrom']
                        .toList()
                        .contains(currentUserId.toLowerCase())) ==
                    false,
          )
          .toList();
      return filteredPosts;
    }
    if (rentString.contains(currentFilterOption.toLowerCase())) {
      filteredPosts = filteredPosts
          .where(
            (post) =>
                (rentString.contains(
                    post['advert']['type'].toString().toLowerCase())) &&
                (post['advert']['hiddenFrom']
                        .toList()
                        .contains(currentUserId.toLowerCase())) ==
                    false,
          )
          .toList();
      return filteredPosts;
    }

    filteredPosts = filteredPosts
        .where((post) =>
            post['advert']['location'].toString().toLowerCase().contains(
                  currentFilterOption.toLowerCase(),
                ) &&
            (post['advert']['hiddenFrom']
                    .toList()
                    .contains(currentUserId.toString())) ==
                false)
        .toList();

    filteredPosts = filteredPosts
        .where((post) =>
            (post['advert']['hiddenFrom']
                .toList()
                .contains(currentUserId.toString())) ==
            false)
        .toList();

    return filteredPosts;
  }

  ///////////////// for posts only ////////////////////////
  if (type == 'posts') {
    var filteredPosts = posts;
    if (appBarSearchString != null) {
      filteredPosts = posts
          .where(
            (post) =>
                post['post']['title']
                    .toString()
                    .contains(appBarSearchString.toString()) ||
                post['post']['text']
                    .toString()
                    .contains(appBarSearchString.toString()) ||
                post['post']['type']
                    .toString()
                    .contains(appBarSearchString.toString()),
          )
          .toList();
    }
    if (currentFilterOption.toLowerCase() == 'افغانستان') {
      filteredPosts = filteredPosts
          .where(
            (post) =>
                (post['post']['hiddenFrom']
                    .toList()
                    .contains(currentUserId.toString())) ==
                false,
          )
          .toList();
      print('end');
      return filteredPosts;
    }

    if (currentFilterOption == appLanguage['myPosts']) {
      filteredPosts = filteredPosts
          .where(
            (post) =>
                post['post']['owner']['id'].toString() ==
                    currentUserId.toString() &&
                (post['post']['hiddenFrom']
                        .toList()
                        .contains(currentUserId.toString())) ==
                    false,
          )
          .toList();
      return filteredPosts;
    }

    if (currentFilterOption.toLowerCase() == appLanguage['myFavorites']) {
      filteredPosts = filteredPosts
          .where(
            (post) =>
                post['post']['favorites']
                    .toList()
                    .contains(currentUserId.toString()) &&
                (post['post']['hiddenFrom']
                        .toList()
                        .contains(currentUserId.toString())) ==
                    false,
          )
          .toList();
      return filteredPosts;
    }

    filteredPosts = filteredPosts
        .where((post) =>
            post['post']['location'].toString().toLowerCase().contains(
                  currentFilterOption.toLowerCase(),
                ) &&
            (post['post']['hiddenFrom']
                    .toList()
                    .contains(currentUserId.toString())) ==
                false)
        .toList();

    filteredPosts = filteredPosts
        .where((post) =>
            (post['post']['hiddenFrom']
                .toList()
                .contains(currentUserId.toString())) ==
            false)
        .toList();
    return filteredPosts;
  }

  //////////////////// For services only /////////////////////

  if (type == 'services') {
    var filteredPosts = posts;
    if (appBarSearchString != null) {
      filteredPosts = posts
          .where(
            (post) =>
                post['post']['title']
                    .toString()
                    .contains(appBarSearchString.toString()) ||
                post['post']['text']
                    .toString()
                    .contains(appBarSearchString.toString()) ||
                post['post']['type']
                    .toString()
                    .contains(appBarSearchString.toString()),
          )
          .toList();
    }
    if (currentFilterOption.toLowerCase() == 'افغانستان') {
      filteredPosts = filteredPosts
          .where(
            (post) =>
                (post['post']['hiddenFrom']
                    .toList()
                    .contains(currentUserId.toString())) ==
                false,
          )
          .toList();
      return filteredPosts;
    }

    if (currentFilterOption == appLanguage['myServices']) {
      filteredPosts = filteredPosts
          .where(
            (post) =>
                post['post']['owner']['id'].toString() ==
                    currentUserId.toString() &&
                (post['post']['hiddenFrom']
                        .toList()
                        .contains(currentUserId.toString())) ==
                    false,
          )
          .toList();
      return filteredPosts;
    }

    if (currentFilterOption.toLowerCase() ==
        appLanguage['myFavorites'].toLowerCase()) {
      filteredPosts = filteredPosts
          .where(
            (post) =>
                post['post']['favorites']
                    .toList()
                    .contains(currentUserId.toString()) &&
                (post['post']['hiddenFrom']
                        .toList()
                        .contains(currentUserId.toString())) ==
                    false,
          )
          .toList();
      return filteredPosts;
    }

    filteredPosts = filteredPosts
        .where((post) =>
            post['post']['location'].toString().toLowerCase().contains(
                  currentFilterOption.toLowerCase(),
                ) &&
            (post['post']['hiddenFrom']
                    .toList()
                    .contains(currentUserId.toString())) ==
                false)
        .toList();

    filteredPosts = filteredPosts
        .where((post) =>
            (post['post']['hiddenFrom']
                .toList()
                .contains(currentUserId.toString())) ==
            false)
        .toList();

    return filteredPosts;
  }
}
