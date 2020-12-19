import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../languages/index.dart';
import '../../providers/authProvider.dart';
import '../../providers/postsProvider.dart';
import '../../screens/messages/messagesList.dart';
import '../../widgets/noContent.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  void initState() {
    super.initState();
    if (mounted) {
      final currentUserId =
          Provider.of<AuthProvider>(context, listen: false).userId;
      Provider.of<PostsProvider>(context, listen: false).updateUserInfo(
          userId: currentUserId,
          field: 'newMessagesCount',
          value: 0,
          context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = getLanguages(context);
    final currentUserId = Provider.of<AuthProvider>(context).userId;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          title: Text(appLanguage['messages']),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width * 1,
        child: _buildContentBody(currentUserId, appLanguage),
      ),
    );
  }

  Widget _buildContentBody(String currentUserId, appLanguage) {
    return StreamBuilder(
        stream: Provider.of<PostsProvider>(context)
            .getAllMessages(userId: currentUserId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return noContent(appLanguage['noMessages'], context);
          }
          if (snapshot.data.documents.toList().length == 0) {
            return noContent(appLanguage['noMessages'], context);
          }
          List tempList = snapshot.data.documents;
          List<DocumentSnapshot> messages = List();
          messages = tempList;
          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final messageId = messages.toList()[index].documentID;
              final conversations = messages.toList()[index]['messages'];
              final about = messages.toList()[index]['aboutWhat'];
              final initiator = messages.toList()[index]['initiator'];
              final unReadMessages = messages.toList()[index]['unReadMessages'];
              return Dismissible(
                onDismissed: (direction) {
                  Provider.of<PostsProvider>(context).deleteAChatRoom(
                      userId: currentUserId, messageId: messageId);
                },
                key: UniqueKey(),
                background: messageSwipeDeleteButton(),
                child: MessagesListTile(
                    conversations: conversations,
                    messageId: messageId,
                    about: about,
                    initiator: initiator,
                    unReadMessages: unReadMessages),
              );
            },
          );
        });
  }

  Widget messageSwipeDeleteButton() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20.0),
      color: Colors.red,
      child: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }
}
