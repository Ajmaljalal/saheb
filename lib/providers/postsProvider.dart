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

  addOneAdvert({
    owner,
    text,
    title,
    type,
    email,
    price,
    phone,
    images,
    location,
  }) {
    try {
      db.collection('adverts').add(
        {
          'comments': [],
          'date': DateTime.now(),
          'likes': 0,
          'owner': owner,
          'text': text,
          'title': title,
          'phone': phone,
          'email': email,
          'price': price,
          'type': type,
          'images': images,
          'location': location
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  deleteOnePost(postId, collection) async {
    try {
      await db.collection(collection).document(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<QuerySnapshot> getAllPosts(String collection) {
    final dataStream =
        db.collection(collection).orderBy("date", descending: true).snapshots();
    return dataStream;
  }

  Stream<DocumentSnapshot> getOnePost(collection, id) {
    var dataStream;
    try {
      dataStream = db.collection(collection).document(id).snapshots();
    } catch (e) {
      print(e.toString());
    }
    return dataStream;
  }

  updatePostLikes(String postId, collection) {
    try {
      db.collection(collection).document(postId).updateData(
        {
          'likes': FieldValue.increment(1),
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  addCommentOnPost({String postId, String text, Map user, String collection}) {
    try {
      db.collection(collection).document(postId).updateData(
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

  updateCommentLikes({String postId, postComment, collection}) async {
    //// add date to work
    try {
      await db.collection(collection).document(postId).updateData(
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
      db.collection(collection).document(postId).updateData(
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

  deleteComment({
    String postId,
    postComment,
    collection,
  }) {
    try {
      db.collection(collection).document(postId).updateData(
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
