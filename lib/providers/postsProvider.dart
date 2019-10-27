import 'package:flutter/foundation.dart';
import 'dummy_data.dart';

class PostsProvider with ChangeNotifier {
  Map _posts = posts;

  get getPosts {
    return _posts;
  }
}
