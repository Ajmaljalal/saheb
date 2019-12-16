import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saheb/providers/authProvider.dart';
import 'package:saheb/screens/messages/chatScreen.dart';
import 'package:saheb/widgets/avatar.dart';
import 'package:saheb/widgets/userNameHolder.dart';

class MessagesListTile extends StatefulWidget {
  final conversations;
  final messageId;
  MessagesListTile({this.conversations, this.messageId});
  @override
  _MessagesListTileState createState() => _MessagesListTileState();
}

class _MessagesListTileState extends State<MessagesListTile> {
  @override
  Widget build(BuildContext context) {
    String messageReceiverId;
    String messageOwnerName;
    final currentUserId = Provider.of<AuthProvider>(context).userId;
    for (int i = 0; i < widget.conversations.length; i++) {
      if (widget.conversations[i]['ownerId'] != currentUserId) {
        messageReceiverId = widget.conversations[i]['ownerId'];
        messageOwnerName = widget.conversations[i]['ownerName'];
        break;
      }
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              messageId: widget.messageId,
              receiverId: messageReceiverId,
              messageOwnerName: messageOwnerName,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]),
          ),
        ),
        padding: EdgeInsets.all(5.0),
        width: MediaQuery.of(context).size.width * 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            imageRenderer(
              height: 60.0,
              width: 60.0,
              photo: widget.conversations[widget.conversations.length - 1]
                  ['ownerPhoto'],
            ),
            Container(
              margin: EdgeInsets.only(
                top: 5.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  userNameHolder(
                    name: widget.conversations[widget.conversations.length - 1]
                        ['ownerName'],
                    fontSize: 20.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Text(
                      widget.conversations[widget.conversations.length - 1]
                          ['text'],
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 13.0,
                        height: 1.0,
                        color: widget.conversations[
                                    widget.conversations.length - 1]['seen'] ==
                                true
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
