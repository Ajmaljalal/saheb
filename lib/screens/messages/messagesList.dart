import 'package:flutter/material.dart';
import '../../screens/messages/chatScreen.dart';
import '../../widgets/avatar.dart';
import '../../widgets/userNameHolder.dart';

class MessagesListTile extends StatefulWidget {
  final conversations;
  final messageId;
  final about;
  final initiator;

  MessagesListTile({
    this.conversations,
    this.messageId,
    this.initiator,
    this.about,
  });
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
              aboutId: widget.about['id'],
              aboutTitle: widget.about['title'],
              aboutPhotoUrl: widget.about['photoUrl'],
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
        padding: const EdgeInsets.all(5.0),
        width: MediaQuery.of(context).size.width * 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            userAvatar(
              height: 40.0,
              width: 40.0,
              photo: widget.initiator['photo'],
            ),
            const SizedBox(
              width: 5.0,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  userNameHolder(
                    name: widget.initiator['name'],
                    fontSize: 25.0,
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
