import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:saheb/util/isRTL.dart';
import 'package:saheb/widgets/avatar.dart';
import 'package:saheb/widgets/emptyBox.dart';
import 'package:shamsi_date/shamsi_date.dart';
import '../widgets/verticalDivider.dart';
import '../constants/constants.dart';
import '../widgets/imageRenderer.dart';
import '../widgets/gridViewImagesRenderer.dart';

class PostMixin {
  Widget cardHeader(
    post,
  ) {
    final shamsiDate = Jalali.fromDateTime(post['date'].toDate());
    final postDate =
        '${shamsiDate.formatter.d.toString()}   ${shamsiDate.formatter.mN}';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        userAvatarHolder(url: post['owner']['photo']),
//        userAvatar(height: 40.0, width: 40.0, photo: post['owner']['photo']),
        Container(
          margin: const EdgeInsets.only(
            top: 5.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              userNameHolder(
                post['owner']['name'],
              ),
              Row(
                children: <Widget>[
                  userLocationHolder(
                    post['location'].toString(),
                  ),
                  CustomVerticalDivider(),
                  Text(
                    postDate,
                    style: kUserLocationStyle,
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget userAvatarHolder({
    url,
  }) {
    return Container(
      padding: EdgeInsets.all(10),
      child: userAvatar(
        height: 40.0,
        width: 40.0,
        photo: url,
      ),
    );
  }

  Widget userNameHolder(
    userName,
  ) {
    return Container(
      child: Text(
        userName,
        style: kUserNameStyle,
      ),
    );
  }

  Widget userLocationHolder(
    location,
  ) {
    return Container(
      child: Text(
        location.trim(),
        style: kUserLocationStyle,
      ),
    );
  }

  Widget postTypeHolder(
    context,
    postType,
    appLanguage,
  ) {
    Color circleColor;
    if (postType == 'مفقودی' || postType == 'Lost') {
      circleColor = Colors.red;
    }
    if (postType == 'پیدا شوی' ||
        postType == 'پیدا شده' ||
        postType == 'Found') {
      circleColor = Colors.green;
    }
    if (postType == 'عاجل' || postType == 'Emergency') {
      circleColor = Colors.orange;
    }

    if (postType != appLanguage['general'] &&
        postType != appLanguage['عمومی']) {
      return Container(
//        color: Colors.green,
        margin: EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        child: Row(
          children: <Widget>[
            Container(
              height: 8.0,
              width: 8.0,
              decoration: BoxDecoration(
                color: circleColor,
                borderRadius: BorderRadius.circular(
                  12.0,
                ),
              ),
              child: Text(''),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 3,
              ),
              child: Text(
                postType,
                textDirection:
                    isRTL(postType) ? TextDirection.rtl : TextDirection.ltr,
                style: kPostTypeTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    } else
      return emptyBox();
  }

  Widget postOptions(
      {context,
      onOpenOptions,
      appLanguage,
      postOwnerId,
      currentUserId,
      isFavorite,
      postImages}) {
    return Container(
      width: 45.0,
      child: FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.symmetric(horizontal: 0.0),
        onPressed: () {
          onOpenOptions(
            context,
            appLanguage,
            currentUserId,
            postOwnerId,
            isFavorite,
            postImages,
          );
        },
        child: Container(
          width: 20.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 5.0,
                width: 5.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Colors.black54,
                ),
              ),
              Container(
                height: 5.0,
                width: 5.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Colors.black54,
                ),
              ),
              Container(
                height: 5.0,
                width: 5.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Colors.black54,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget postTittleHolder(
    title,
    fontSize,
    context,
  ) {
    return title != null
        ? Padding(
            padding: const EdgeInsets.only(
              right: 10.0,
              left: 10.0,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.99,
              child: Text(
                title.toString().trim(),
                textDirection:
                    isRTL(title) ? TextDirection.rtl : TextDirection.ltr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
            ),
          )
        : emptyBox();
  }

  Widget postContent({
    text,
    List images,
    flag,
    onRevealMoreText,
    appLanguage,
    context,
    imagesScrollView,
    price,
    fontSize,
    postDate,
  }) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            width: MediaQuery.of(context).size.width * 1,
            child: text != null
                ? Text(
                    text.toString().trim(),
                    textDirection:
                        isRTL(text) ? TextDirection.rtl : TextDirection.ltr,
                    maxLines: flag ? 50 : 3,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.black,
                    ),
                  )
                : emptyBox(),
          ),
          revealMoreText(text, flag, onRevealMoreText, appLanguage['more']),
          images.length > 0
              ? Container(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: GridViewImageRenderer(images: images),
                )
              : emptyBox(),
        ],
      ),
    );
  }

  Widget revealMoreText(
    text,
    flag,
    onRevealMoreText,
    moreText,
  ) {
    return text.toString().length < 120
        ? emptyBox()
        : !flag
            ? Container(
                height: 20.0,
                child: InkWell(
                  onTap: onRevealMoreText,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          bottom: 0.0,
                          top: 0.0,
                          right: 8.0,
                        ),
                        child: Text(
                          moreText,
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : emptyBox();
  }

  Widget postImages({
    image,
    context,
    scrollView,
  }) {
    double imagesWidth = MediaQuery.of(context).size.width * 1;
    return Center(
      child: Container(
          height: 280.0,
          child: singleImageRenderer(
            image,
            context,
            imagesWidth,
            BoxFit.cover,
          )),
    );
  }

  Widget postLikesCommentsCountHolder({
    post,
    appLanguage,
    userId,
    isLiked,
  }) {
    final comments = post['comments'];
    final likes = post['likes'];
    final String commentsHolderText = comments.length > 1
        ? appLanguage['multiComments']
        : appLanguage['singleComment'];
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                comments.length.toString(),
                style: const TextStyle(fontSize: 13.0),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                commentsHolderText.toString(),
                style: const TextStyle(fontSize: 13.0),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                likes.length.toString(),
                style: const TextStyle(fontSize: 13.0),
              ),
              const SizedBox(
                width: 5,
              ),
              Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                size: 13.0,
                color: Colors.purple,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget postActionButtons({
    onClickComment,
    String postId,
    userId,
    post,
    String postTitle,
    flag,
    updateLikes,
    isLiked,
    context,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkResponse(
            splashColor: Colors.purple[200],
            radius: 25.0,
            child: Icon(
              FontAwesomeIcons.thumbsUp,
              color: isLiked ? Colors.purple : Colors.grey,
              size: 20,
            ),
            onTap: () {
              updateLikes(
                  postLikes: post['likes'], userId: userId, isLiked: isLiked);
            },
          ),
          SizedBox(
            width: 80.0,
          ),
          InkResponse(
            splashColor: Colors.grey[200],
            radius: 25.0,
            child: const Icon(
              FontAwesomeIcons.comment,
              color: Colors.grey,
              size: 20,
            ),
            onTap: () {
              if (flag == 'details') {
                onClickComment();
              } else
                onClickComment(postId, postTitle);
            },
          ),
          SizedBox(
            width: 80.0,
          ),
          postHotnessIndicator(post['likes'].length),
        ],
      ),
    );
  }

  Widget postHotnessIndicator(postLikes) {
    IconData icon;
    if (postLikes == 0) {
      icon = MaterialCommunityIcons.signal_cellular_outline;
    }
    if (postLikes > 0 && postLikes <= 5) {
      icon = MaterialCommunityIcons.signal_cellular_1;
    }

    if (postLikes > 5 && postLikes <= 10) {
      icon = MaterialCommunityIcons.signal_cellular_2;
    }

    if (postLikes > 10 && postLikes <= 15) {
      icon = MaterialCommunityIcons.signal_cellular_3;
    }

    if (postLikes > 15) {
      icon = MaterialCommunityIcons.fire;
    }

    return Container(
      child: Icon(
        icon,
        color: postLikes > 15 ? Colors.red : Colors.purple,
      ),
    );
  }

  //////////////// POST DETAILS SCREEN////////////////////
  ///////////////////////////////////////////////////////

  List individualCommentRenderer({
    comments,
    likeComment,
    deleteComment,
    userId,
    postOwnerId,
    context,
  }) {
    return comments.map((comment) {
      return Row(
        children: <Widget>[
          Container(
            child: userAvatarHolder(
              url: comment['user']['photo'],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15.0, bottom: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                commentTextHolder(
                  postComment: comment,
                  likeComment: likeComment,
                  userId: userId,
                  postOwnerId: postOwnerId,
                  deleteComment: deleteComment,
                  context: context,
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget commentTextHolder({
    postComment,
    likeComment,
    deleteComment,
    userId,
    postOwnerId,
    context,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300],
          width: 1.5,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
        ),
      ),
      padding: EdgeInsets.only(
        top: 10.0,
        right: 10.0,
        left: 10.0,
        bottom: 2.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          userNameHolder(postComment['user']['name'].toString()),
          Text(
            postComment['text'].toString(),
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          commentActionButtons(
            comment: postComment,
            likeComment: likeComment,
            deleteComment: deleteComment,
            userId: userId,
            postOwnerId: postOwnerId,
          ),
        ],
      ),
    );
  }

  Widget commentActionButtons({
    comment,
    likeComment,
    deleteComment,
    userId,
    postOwnerId,
  }) {
    bool canDeleteComment =
        comment['user']['id'] == userId || postOwnerId == userId;
    final commentLikes = comment['likes'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                FontAwesomeIcons.thumbsUp,
                color: Colors.cyan,
                size: 18,
              ),
              onPressed: () async {
                await likeComment(comment, userId);
              },
            ),
            canDeleteComment
                ? IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.cyan,
                      size: 24,
                    ),
                    onPressed: () {
                      deleteComment(comment);
                    },
                  )
                : SizedBox(
                    width: 0.0,
                  ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              commentLikes.length.toString(),
            ),
            SizedBox(width: 5),
            Icon(
              FontAwesomeIcons.heart,
              size: 15.0,
            ),
          ],
        ),
      ],
    );
  }

  Widget addCommentTextField({
    focusNode,
    appLanguage,
    onChange,
    onSubmit,
    userId,
    onClearTextField,
    context,
  }) {
    final TextEditingController _controller = new TextEditingController();
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: .4,
          ),
        ),
      ),
      child: Container(
        padding: kPaddingAll5,
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                left: 5.0,
                bottom: 5.0,
              ),
              child: InkWell(
                child: Icon(
                  MaterialCommunityIcons.send_circle,
                  textDirection: TextDirection.rtl,
                  color: Colors.purple,
                  size: 36.0,
                ),
                onTap: () {
                  onSubmit();
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => _controller.clear());
                },
              ),
            ),
            Expanded(
              child: TextField(
                onChanged: onChange,
                focusNode: focusNode,
                autocorrect: false,
                controller: _controller,
                cursorColor: Colors.black,
                autofocus: false,
                maxLines: null,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.purple,
//                      size: 20,
                    ),
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) => _controller.clear(),
                      );
                      onClearTextField();
                    },
                  ),
                  contentPadding: kPaddingAll10_10,
                  fillColor: Colors.white,
                  labelText: appLanguage['addComment'],
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                  enabledBorder: kOutlineInputBorderGrey,
                  focusedBorder: kOutlineInputBorderPurple,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                right: 5.0,
                bottom: 5.0,
              ),
              child: InkWell(
                child: Icon(
                  MaterialIcons.cancel,
                  color: Colors.grey,
                  size: 36.0,
                ),
                onTap: () {
                  onClearTextField();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
