import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/authProvider.dart';
import '../util/deleteImages.dart';
import '../util/uuid.dart';

final Firestore db = Firestore.instance;

class PostsProvider with ChangeNotifier {
  Future<void> addOnePost({
    owner,
    id,
    date,
    text,
    location,
    images,
  }) async {
    try {
      await db.collection('posts').document(id).setData(
        {
          'id': id,
          'comments': [],
          'date': date,
          'favorites': [],
          'hiddenFrom': [],
          'likes': [],
          'owner': owner,
          'text': text,
          'images': images,
          'location': location,
          'promoted': false,
          'promoStartDate': null,
          'promoEndDate': null,
          'promoMoneyAmount': 0,
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> saveRecordSnapshot({
    id,
    date,
    location,
    type,
    collection,
  }) async {
    try {
      await db.collection(collection).document(id).setData(
        {
          'date': date,
          'location': location,
          'type': type,
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> editOnePost({
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
    promoted,
    promoStartDate,
    promoEndDate,
    promoMoneyAmount,
  }) async {
    try {
      await db.collection('posts').document(postId).setData(
        {
          'id': postId,
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
          'promoted': promoted,
          'promoStartDate': promoStartDate,
          'promoEndDate': promoEndDate,
          'promoMoneyAmount': promoMoneyAmount,
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addOneAdvert({
    id,
    date,
    owner,
    text,
    title,
    type,
    email,
    price,
    phone,
    images,
    location,
  }) async {
    try {
      await db.collection('adverts').document(id).setData(
        {
          'id': id,
          'date': date,
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
          'location': location,
          'promoted': false,
          'promoStartDate': null,
          'promoEndDate': null,
          'promoMoneyAmount': 0,
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addOneService({
    id,
    date,
    owner,
    desc,
    title,
    type,
    email,
    fullAddress,
    phone,
    images,
    location,
  }) async {
    try {
      await db.collection('services').document(id).setData(
        {
          'id': id,
          'date': date,
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
          'location': location,
          'promoted': false,
          'promoStartDate': null,
          'promoEndDate': null,
          'promoMoneyAmount': 0,
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteOneRecord(postId, collection, images) async {
    try {
      await db.collection(collection).document(postId).delete();
      if (images != null) {
        await deleteImagesFromDB(images: images, collection: collection);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> favoriteAPost(postId, collection, userId, isFavorite) async {
    if (isFavorite) {
      try {
        await db.collection(collection).document(postId).updateData(
          {
            'favorites': FieldValue.arrayRemove(
              [userId],
            ),
          },
        );
      } catch (e) {
        print(e.toString());
      }
    } else {
      try {
        await db.collection(collection).document(postId).updateData(
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
  }

  Future<void> hideAPost(postId, collection, userId) async {
    try {
      await db.collection(collection).document(postId).updateData(
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

  Future<void> reportAPost(post, postId) async {
    try {
      await db.collection('reported').document(postId).setData({
        'id': post['id'],
        'text': post['text'],
        'images': post['images'],
        'owner': post['owner']['id'],
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<QuerySnapshot> getAllPosts(
    String collection,
  ) {
    final dataStream =
        db.collection(collection).orderBy("date", descending: true).snapshots();
    return dataStream;
  }

  Stream<QuerySnapshot> getMorePosts(
    String collection,
    int numberOfPosts,
    currentLastPostId,
//    String location,
  ) {
    final dataStream = db
        .collection(collection)
        .orderBy("date", descending: true)
        .startAfterDocument(currentLastPostId)
//        .where('location', isEqualTo: location)
        .limit(numberOfPosts)
        .snapshots();
    return dataStream;
  }

  Stream<QuerySnapshot> getAllSnapshots(
    String collection,
  ) {
    final dataStream = db
        .collection(collection)
        .orderBy("date", descending: true)
//        .where('location', isEqualTo: location)
        .limit(10)
        .snapshots();
    return dataStream;
  }

  Stream<QuerySnapshot> getInitialPosts(
    String collection,
    int numberOfPosts,
  ) {
    final dataStream = db
        .collection(collection)
        .orderBy("date", descending: true)
        .limit(numberOfPosts)
        .snapshots();
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

  Future<void> updatePostLikes(
    String postId,
    collection,
    userId,
    isLiked,
  ) async {
    if (isLiked) {
      try {
        await db.collection(collection).document(postId).updateData(
          {
            'likes': FieldValue.arrayRemove(
              [userId],
            ),
          },
        );
      } catch (e) {
        print(e.toString());
      }
    } else {
      try {
        await db.collection(collection).document(postId).updateData(
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
  }

  Future<void> addCommentOnPost({
    String postId,
    String text,
    Map user,
    String collection,
  }) async {
    try {
      await db.collection(collection).document(postId).updateData(
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

  Future<void> updateCommentLikes({
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

  Future<void> deleteComment({
    String postId,
    postComment,
    collection,
  }) async {
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

  Future<void> toggleServiceOpenClose({
    serviceId,
    userId,
    openClose,
  }) async {
    try {
      await db.collection('services').document(serviceId).updateData(
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

  Future<void> replyToAConversation({
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

  Future<void> startNewConversation({
    String receiverId,
    String ownerLocation,
    String senderId,
    String senderName,
    String senderPhoto,
    String messageId,
    String text,
    initiator,
    aboutWhat,
  }) async {
    try {
      await db
          .collection('messages')
          .document(senderId)
          .collection('chat-rooms')
          .document(messageId)
          .setData(
        {
          'messages': [
            {
              'date': DateTime.now(),
              'ownerId': senderId,
              'ownerLocation': ownerLocation,
              'ownerName': senderName,
              'ownerPhoto': senderPhoto,
              'seen': false,
              'text': text,
            }
          ],
          'initiator': initiator,
          'aboutWhat': aboutWhat,
        },
      );

      await db
          .collection('messages')
          .document(receiverId)
          .collection('chat-rooms')
          .document(messageId)
          .setData(
        {
          'messages': [
            {
              'date': DateTime.now(),
              'ownerId': senderId,
              'ownerLocation': ownerLocation,
              'ownerName': senderName,
              'ownerPhoto': senderPhoto,
              'seen': false,
              'text': text,
            }
          ],
          'initiator': {
            'id': senderId,
            'name': senderName,
            'photo': senderPhoto,
          },
          'aboutWhat': aboutWhat,
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteAChatRoom({
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

  ///////////////// Users //////////////////////////////
  Stream<DocumentSnapshot> getOneUser({userId}) {
    var dataStream;
    try {
      dataStream = db.collection('users').document(userId).snapshots();
    } catch (e) {
      print(e.toString());
    }
    return dataStream;
  }

  Future<void> updateUserInfo({
    userId,
    field,
    value,
    context,
  }) async {
    try {
      final user = db.collection('users').document(userId);
      if (user != null) {
        await user.setData(
          {'$field': value},
          merge: true,
        );
      }
      if (field == 'photoUrl') {
        await Provider.of<AuthProvider>(context)
            .updateUserPhoto(photoUrl: value);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
