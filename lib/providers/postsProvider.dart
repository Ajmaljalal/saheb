import 'package:flutter/foundation.dart';
import '../util/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final Firestore db = Firestore.instance;

class PostsProvider with ChangeNotifier {
  addOnePost({
    owner,
    text,
    title,
    type,
    images,
  }) {
    try {
      db.collection('posts').add(
        {
          'comments': [],
          'date': DateTime.now(),
          'likes': 0,
          'owner': owner,
          'text': text,
          'title': title,
          'type': type,
          'images': images,
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  deleteOnePost(postId) async {
    try {
      await db.collection('posts').document(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

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
      db.collection('posts').document(postId).updateData(
        {
          'likes': FieldValue.increment(1),
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  addCommentOnPost({String postId, String text, Map user}) {
    try {
      db.collection('posts').document(postId).updateData(
        {
          'comments': FieldValue.arrayUnion(
            [
              {
                'id': Uuid().generateV4(),
                'text': text,
                'likes': 0,
                'user': user,
                'date': DateTime.now(),
              }
            ],
          ),
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  updateCommentLikes({String postId, postComment}) {
    //// add date to work
    try {
      db.collection('posts').document(postId).updateData(
        {
          'comments': FieldValue.arrayRemove(
            [
              {
                'date': postComment['date'],
                'id': postComment['id'],
                'text': postComment['text'],
                'likes': postComment['likes'],
                'user': postComment['user'],
              }
            ],
          )
        },
      );
      db.collection('posts').document(postId).updateData(
        {
          'comments': FieldValue.arrayUnion(
            [
              {
                'date': postComment['date'],
                'id': postComment['id'],
                'text': postComment['text'],
                'likes': postComment['likes'] + 1,
                'user': postComment['user'],
              }
            ],
          )
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  deleteComment({String postId, postComment}) {
    try {
      db.collection('posts').document(postId).updateData(
        {
          'comments': FieldValue.arrayRemove(
            [
              {
                'date': postComment['date'],
                'id': postComment['id'],
                'text': postComment['text'],
                'likes': postComment['likes'],
                'user': postComment['user'],
              }
            ],
          )
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }
}
