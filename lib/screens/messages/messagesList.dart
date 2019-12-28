import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saheb/providers/authProvider.dart';
import 'package:saheb/screens/messages/chatScreen.dart';
import 'package:saheb/widgets/avatar.dart';
import 'package:saheb/widgets/userNameHolder.dart';

class MessagesListTile extends StatefulWidget {
  final conversations;
  final messageId;
  final about;
  final initiator;

  MessagesListTile(
      {this.conversations, this.messageId, this.initiator, this.about});
  @override
  _MessagesListTileState createState() => _MessagesListTileState();
}

class _MessagesListTileState extends State<MessagesListTile> {
  @override
  Widget build(BuildContext context) {
    String messageInitiatorId = widget.initiator['id'];
    String messageInitiatorName = widget.initiator['name'];
    String messageInitiatorPhoto = widget.initiator['photoUrl'];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              messageId: widget.messageId,
              initiatorId: messageInitiatorId,
              initiatorName: messageInitiatorName,
              initiatorPhoto: messageInitiatorPhoto,
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
            userAvatar(
              height: 60.0,
              width: 60.0,
              photo: widget.initiator['photo'],
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
                    name: widget.initiator['name'],
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
