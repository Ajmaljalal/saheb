import 'package:flutter/foundation.dart';
import '../util/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final Firestore db = Firestore.instance;

class PostsProvider with ChangeNotifier {
  addOnePost({
    owner,
    text,
    title,
    location,
    type,
    images,
  }) {
    try {
      db.collection('posts').add(
        {
          'comments': [],
          'date': DateTime.now(),
          'favorites': [],
          'hiddenFrom': [],
          'likes': [],
          'owner': owner,
          'text': text,
          'title': title,
          'type': type,
          'images': images,
          'location': location,
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  editOnePost({
    postId,
    owner,
    text,
    title,
    location,
    type,
    images,
    comments,
    date,
    hiddenFrom,
    likes,
    favorites,
  }) {
    try {
      db.collection('posts').document(postId).setData(
        {
          'comments': comments,
          'date': date,
          'favorites': favorites,
          'hiddenFrom': hiddenFrom,
          'likes': likes,
          'owner': owner,
          'text': text,
          'title': title,
          'type': type,
          'images': images,
          'location': location,
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
          'date': DateTime.now(),
          'owner': owner,
          'text': text,
          'title': title,
          'hiddenFrom': [],
          'favorites': [],
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

  addOneService({
    owner,
    desc,
    title,
    type,
    email,
    fullAddress,
    phone,
    images,
    location,
  }) {
    try {
      db.collection('services').add(
        {
          'date': DateTime.now(),
          'owner': owner,
          'desc': desc,
          'open': true,
          'title': title,
          'note': null,
          'hiddenFrom': [],
          'favorites': [],
          'phone': phone,
          'email': email,
          'fullAddress': fullAddress,
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

  favoriteAPost(postId, collection, userId) async {
    try {
      db.collection(collection).document(postId).updateData(
        {
          'favorites': FieldValue.arrayUnion(
            [userId],
          ),
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  hideAPost(postId, collection, userId) async {
    try {
      db.collection(collection).document(postId).updateData(
        {
          'hiddenFrom': FieldValue.arrayUnion(
            [userId],
          ),
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  reportAPost(post, postId) {
    try {
      db.collection('reported').document(postId).setData(
            post,
          );
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

  updatePostLikes(String postId, collection, userId) {
    try {
      db.collection(collection).document(postId).updateData(
        {
          'likes': FieldValue.arrayUnion(
            [userId],
          ),
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  addCommentOnPost({
    String postId,
    String text,
    Map user,
    String collection,
  }) {
    try {
      db.collection(collection).document(postId).updateData(
        {
          'comments': FieldValue.arrayUnion(
            [
              {
                'id': Uuid().generateV4(),
                'text': text,
                'likes': [],
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

  updateCommentLikes({
    String postId,
    postComment,
    collection,
    userId,
  }) async {
    final List commentLikes = new List<String>.from(postComment['likes']);
    commentLikes.add(userId);
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
                'likes': commentLikes,
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

  ////////////////// service end points ///////////////////////////////
  Stream<QuerySnapshot> getAllServices(
    type,
  ) {
    final dataStream = db
        .collection('services')
        .where("type", isEqualTo: type)
        .orderBy("date", descending: true)
        .snapshots();
    return dataStream;
  }

  toggleServiceOpenClose({
    serviceId,
    userId,
    openClose,
  }) {
    try {
      db.collection('services').document(serviceId).updateData(
        {
          'open': openClose,
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  ///////////////////// messages end points ///////////////////////////
  Stream<QuerySnapshot> getAllMessages({
    String userId,
  }) {
    final dataStream = db
        .collection('messages')
        .document(userId)
        .collection('chat-rooms')
        .snapshots();
    return dataStream;
  }

  replyToAConversation({
    String userId,
    String messageReceiverUserId,
    String messageId,
    String ownerLocation,
    String ownerName,
    String ownerPhoto,
    String text,
  }) async {
    try {
      await db
          .collection('messages')
          .document(userId)
          .collection('chat-rooms')
          .document(messageId)
          .updateData(
        {
          'messages': FieldValue.arrayUnion(
            [
              {
                'date': DateTime.now(),
                'ownerId': userId,
                'ownerLocation': ownerLocation,
                'ownerName': ownerName,
                'ownerPhoto': ownerPhoto,
                'seen': false,
                'text': text,
              }
            ],
          ),
        },
      );

      await db
          .collection('messages')
          .document(messageReceiverUserId)
          .collection('chat-rooms')
          .document(messageId)
          .updateData(
        {
          'messages': FieldValue.arrayUnion(
            [
              {
                'date': DateTime.now(),
                'ownerId': userId,
                'ownerLocation': ownerLocation,
                'ownerName': ownerName,
                'ownerPhoto': ownerPhoto,
                'seen': false,
                'text': text,
              }
            ],
          ),
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<DocumentSnapshot> getOneConversation({
    chatRoomId,
    userId,
    messagesCollection,
  }) {
    final dataStream = db
        .collection('messages')
        .document(userId)
        .collection('chat-rooms')
        .document(chatRoomId)
        .snapshots();
    return dataStream;
  }

  startNewConversation({
    String messageReceiverUserId,
    String ownerLocation,
    String userId,
    String ownerName,
    String ownerPhoto,
    String messageId,
    String text,
    initiator,
  }) {
    try {
      db
          .collection('messages')
          .document(userId)
          .collection('chat-rooms')
          .document(messageId)
          .setData(
        {
          'messages': [
            {
              'date': DateTime.now(),
              'ownerId': userId,
              'ownerLocation': ownerLocation,
              'ownerName': ownerName,
              'ownerPhoto': ownerPhoto,
              'seen': false,
              'text': text,
            }
          ],
          'initiator': initiator
        },
      );

      db
          .collection('messages')
          .document(messageReceiverUserId)
          .collection('chat-rooms')
          .document(messageId)
          .setData(
        {
          'messages': [
            {
              'date': DateTime.now(),
              'ownerId': userId,
              'ownerLocation': ownerLocation,
              'ownerName': ownerName,
              'ownerPhoto': ownerPhoto,
              'seen': false,
              'text': text,
            }
          ],
          'initiator': {
            'id': userId,
            'name': ownerName,
            'photo': ownerPhoto,
          }
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  deleteAChatRoom({
    String userId,
    String messageId,
  }) async {
    try {
      await db
          .collection('messages')
          .document(userId)
          .collection('chat-rooms')
          .document(messageId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
