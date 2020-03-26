import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/posts/post.dart';
import '../providers/authProvider.dart';
import '../util/deleteImages.dart';
import '../util/uuid.dart';

final Firestore db = Firestore.instance;

class PostsStore with ChangeNotifier {
  List<Post> _localPosts = [];
  List<Post> _provincePosts = [];
  List<Post> _countryPosts = [];
  DocumentSnapshot _lastLocalPost;
  DocumentSnapshot _lastProvincePost;
  DocumentSnapshot _lastCountryPost;

  DocumentSnapshot get getLastLocalPost {
    return _lastLocalPost;
  }

  DocumentSnapshot get getLastProvincePost {
    return _lastProvincePost;
  }

  DocumentSnapshot get getLastCountryPost {
    return _lastCountryPost;
  }

  void setLastLocalPost(DocumentSnapshot post) {
    _lastLocalPost = post;
  }

  void setLastProvincePost(DocumentSnapshot post) {
    _lastProvincePost = post;
  }

  void setLastCountryPost(DocumentSnapshot post) {
    _lastCountryPost = post;
  }

  List<Post> get getLocalPosts {
    return _localPosts;
  }

  List<Post> get getProvincePosts {
    return _provincePosts;
  }

  List<Post> get getCountryPosts {
    return _countryPosts;
  }

  void addPostToStore(posts, String location) {
    if (location == 'local') {
      _localPosts.addAll(posts);
    }
    if (location == 'province') {
      _provincePosts.addAll(posts);
    }
    if (location == 'country') {
      _countryPosts.addAll(posts);
    }

    notifyListeners();
  }
}
