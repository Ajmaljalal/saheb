import 'package:com.pywast.pywast/widgets/imageRenderer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import '../../languages/index.dart';
import '../../providers/authProvider.dart';
import '../../providers/locationProvider.dart';
import '../../providers/postsProvider.dart';
import '../../util/uuid.dart';
import '../../widgets/avatar.dart';
import '../../widgets/emptyBox.dart';
import '../../widgets/noContent.dart';
import '../../widgets/wait.dart';

class ChatScreen extends StatefulWidget {
  final messageId;
  final initiatorPhoto;
  final initiatorId;
  final initiatorName;
  final aboutId;
  final aboutTitle;
  final aboutPhotoUrl;
  final unReadMessages;

  ChatScreen(
      {this.initiatorId,
      this.messageId,
      this.initiatorName,
      this.initiatorPhoto,
      this.aboutId,
      this.aboutTitle,
      this.aboutPhotoUrl,
      this.unReadMessages});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String _text;
  String messageId;

  ScrollController _scrollController;
  TextEditingController _messageInputFieldController;
  FocusNode _messageInputFieldFocusNode = FocusNode();

  handleTextInputFieldChange(value) {
    setState(() {
      _text = value;
    });
  }

  onReplyToAConversation() async {
    if (_text == null || _text.trim().length == 0) {
      return;
    }
    final user = await Provider.of<AuthProvider>(context).currentUser;
    final currentUserId =
        Provider.of<AuthProvider>(context, listen: false).userId;
    final userLocality =
        Provider.of<LocationProvider>(context, listen: false).getUserLocality;
    await Provider.of<PostsProvider>(context, listen: false)
        .replyToAConversation(
      ownerName: user.displayName,
      ownerLocation: userLocality,
      messageReceiverUserId: widget.initiatorId,
      ownerPhoto: user.photoUrl,
      userId: currentUserId,
      messageId: messageId,
      text: _text,
    );
    setState(() {
      _text = null;
    });
  }

  onStartNewConversation() async {
    if (_text == null || _text.length == 0) {
      return;
    }
    final initiator = {
      'id': widget.initiatorId,
      'name': widget.initiatorName,
      'photo': widget.initiatorPhoto,
    };
    final aboutWhat = {
      'id': widget.aboutId,
      'title': widget.aboutTitle,
      'photoUrl': widget.aboutPhotoUrl
    };
    final user = await Provider.of<AuthProvider>(context).currentUser;
    final newMessageId = Uuid().generateV4();
    final currentUserId =
        Provider.of<AuthProvider>(context, listen: false).userId;
    final userLocality =
        Provider.of<LocationProvider>(context, listen: false).getUserLocality;
    await Provider.of<PostsProvider>(context, listen: false)
        .startNewConversation(
      senderName: user.displayName,
      ownerLocation: userLocality,
      senderPhoto: user.photoUrl,
      senderId: currentUserId,
      receiverId: widget.initiatorId,
      messageId: newMessageId,
      text: _text,
      initiator: initiator,
      aboutWhat: aboutWhat,
    );
    setState(() {
      messageId = newMessageId;
      _text = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _messageInputFieldController = TextEditingController();
    if (mounted && widget.unReadMessages) {
      final currentUserId =
          Provider.of<AuthProvider>(context, listen: false).userId;
      Provider.of<PostsProvider>(context, listen: false).updateUnreadMessages(
          conversationId: widget.messageId, userId: currentUserId);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _messageInputFieldController.dispose();
    _messageInputFieldFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.messageId != null) {
      setState(() {
        messageId = widget.messageId;
      });
    }
    final currentUserId = Provider.of<AuthProvider>(context).userId;
    final appLanguage = getLanguages(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          title: Text(widget.initiatorName != null ? widget.initiatorName : ''),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 1,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.grey[100],
              height: MediaQuery.of(context).size.height * .09,
              padding: const EdgeInsets.all(
                4.0,
              ),
              child: Row(
                children: <Widget>[
                  singleImageRenderer(
                    widget.aboutPhotoUrl,
                    context,
                    40.0,
                    BoxFit.fill,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      widget.aboutTitle,
                      style: const TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            messageId != null
                ? Expanded(
                    child: GestureDetector(
                      onTap: () => _messageInputFieldFocusNode.unfocus(),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: StreamBuilder(
                          stream: Provider.of<PostsProvider>(context)
                              .getOneConversation(
                                  chatRoomId: messageId, userId: currentUserId),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return wait(appLanguage['wait'], context);
                            }
                            var conversations = snapshot.data['messages'];
                            var reversedConversations =
                                conversations.toList().reversed.toList();
                            return ListView.builder(
                              controller: _scrollController,
                              reverse: true,
                              shrinkWrap: true,
                              itemCount: reversedConversations.toList().length,
                              itemBuilder: (context, index) {
                                var conversation =
                                    reversedConversations.toList()[index];
                                return conversationHolderTile(
                                  conversation: conversation,
                                  userId: currentUserId,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: noContent(appLanguage['noMessages'], context),
                  ),
            Container(
              color: Colors.grey[100],
              padding: EdgeInsets.symmetric(
                horizontal: 5.0,
              ),
              child: Row(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      messageId != null
                          ? onReplyToAConversation()
                          : onStartNewConversation();
                      Future.delayed(Duration(milliseconds: 50)).then((_) {
                        _messageInputFieldController.clear();
                      });
                      Future.delayed(Duration(microseconds: 100), () {
                        if (_scrollController.hasClients) {
                          _scrollController.animateTo(
                            0.0,
                            curve: Curves.easeOut,
                            duration: const Duration(milliseconds: 300),
                          );
                        }
                      });
                    },
                    child: const Icon(
                      MaterialCommunityIcons.send_circle,
                      textDirection: TextDirection.ltr,
                      size: 30.0,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _messageInputFieldController,
                      maxLines: null,
                      focusNode: _messageInputFieldFocusNode,
                      onChanged: (value) {
                        handleTextInputFieldChange(value);
                      },
                      decoration: InputDecoration(
                        hintText: appLanguage['typeMessage'],
                        hintStyle: const TextStyle(fontSize: 14.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget conversationHolderTile({
    conversation,
    userId,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        child: messageBubble(
          message: conversation['text'],
          ownerId: conversation['ownerId'],
          userId: userId,
          ownerPhoto: conversation['ownerPhoto'],
        ),
      ),
    );
  }

  messageBubble({
    message,
    ownerId,
    userId,
    ownerPhoto,
  }) {
    bool isOwner = ownerId == userId ? true : false;

    if (isOwner) {
      return Row(
        mainAxisAlignment:
            isOwner ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: <Widget>[
          isOwner
              ? emptyBox()
              : userAvatar(
                  height: 35.0,
                  width: 35.0,
                  photo: ownerPhoto,
                ),
          const SizedBox(
            width: 5.0,
          ),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                minWidth: 50.0,
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              margin: const EdgeInsets.only(bottom: 12.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                  bottomLeft:
                      isOwner ? Radius.circular(20.0) : Radius.circular(0.0),
                  bottomRight:
                      isOwner ? Radius.circular(0.0) : Radius.circular(20.0),
                ),
                color: isOwner
                    ? Colors.cyanAccent.withOpacity(0.2)
                    : Colors.grey[100],
              ),
              child: Text(message),
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment:
            isOwner ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(
              minWidth: 50.0,
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            margin: const EdgeInsets.only(bottom: 12.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0),
                bottomLeft: isOwner
                    ? const Radius.circular(20.0)
                    : const Radius.circular(0.0),
                bottomRight: isOwner
                    ? const Radius.circular(0.0)
                    : const Radius.circular(20.0),
              ),
              color: isOwner
                  ? Colors.cyanAccent.withOpacity(0.2)
                  : Colors.grey[100],
            ),
            child: Text(message),
          ),
          const SizedBox(
            width: 5.0,
          ),
          isOwner
              ? emptyBox()
              : userAvatar(
                  height: 35.0,
                  width: 35.0,
                  photo: ownerPhoto,
                ),
        ],
      );
    }
  }
}
