import 'package:flutter/foundation.dart';
import '../util/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final Firestore db = Firestore.instance;

class PostsProvider with ChangeNotifier {
  Stream<QuerySnapshot> getAllPosts() {
    final dataStream = db.collection('posts').snapshots();
    return dataStream;
  }

  Stream<DocumentSnapshot> getOnePost(id) {
    var dataStream;
    try {
      dataStream = db.collection('posts').document(id).snapshots();
    } catch (e) {
      print(e.toString());
    }
    return dataStream;
  }

  updatePostLikes(String postId) {
    try {
      db
          .collection('posts')
          .document(postId)
          .updateData({'likes': FieldValue.increment(1)});
    } catch (e) {
      print(e.toString());
    }
  }

  addCommentOnPost({String postId, String text, Map user}) {
    try {
      db.collection('posts').document(postId).updateData({
        'comments': FieldValue.arrayUnion([
          {
            'id': Uuid().generateV4(),
            'text': text,
            'likes': 0,
            'user': user,
          }
        ])
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
