filterList({
  List posts,
  appBarSearchString,
  currentFilterOption,
  appLanguage,
  currentUserId,
  type,
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
      filteredPosts = filteredPosts
          .where(
            (post) =>
                (post['advert']['hiddenFrom']
                    .toList()
                    .contains(currentUserId.toString())) ==
                false,
          )
          .toList();
      return filteredPosts;
    }

    if (currentFilterOption == appLanguage['myPosts']) {
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

    if (currentFilterOption.toLowerCase() == appLanguage['myFavorites']) {
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
}
