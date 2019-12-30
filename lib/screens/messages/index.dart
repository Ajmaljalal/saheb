import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../languages/index.dart';
import '../../providers/authProvider.dart';
import '../../providers/postsProvider.dart';
import '../../screens/messages/messagesList.dart';
import '../../widgets/noContent.dart';

class Messages extends StatefulWidget {
  final messages;
  Messages({this.messages});
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    final appLanguage = getLanguages(context);
    final currentUserId = Provider.of<AuthProvider>(context).userId;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          title: Text(appLanguage['messages']),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width * 1,
        child: widget.messages != null && widget.messages.length > 0
            ? ListView.builder(
                itemCount: widget.messages.length,
                itemBuilder: (context, index) {
                  final messageId =
                      widget.messages.toList()[index]['messageId'];
                  var conversations =
                      widget.messages.toList()[index]['conversations'];
                  final about = widget.messages.toList()[index]['about'];
                  final initiator =
                      widget.messages.toList()[index]['initiator'];

                  return Dismissible(
                    onDismissed: (direction) {
                      widget.messages.removeAt(index);
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
                    ),
                  );
                },
              )
            : noContent(appLanguage['noMessages'], context),
      ),
    );
  }

  Widget messageSwipeDeleteButton() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      color: Colors.red,
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }
}
