import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:saheb/util/isRTL.dart';
import 'package:saheb/widgets/emptyBox.dart';
import 'package:shamsi_date/shamsi_date.dart';
import '../widgets/verticalDivider.dart';
import '../constants/constants.dart';
import '../widgets/imageRenderer.dart';

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
      width: 60.0,
      height: 60.0,
      padding: EdgeInsets.all(10),
      child: CircleAvatar(
          backgroundImage: NetworkImage(
        url != null
            ? url
            : 'https://cdn.pixabay.com/photo/2014/03/24/17/19/teacher-295387_1280.png',
      )),
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
    return Padding(
      padding: const EdgeInsets.only(
        right: 10.0,
        left: 10.0,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.99,
        child: Text(
          title.trim(),
          textDirection: isRTL(title) ? TextDirection.rtl : TextDirection.ltr,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
      ),
    );
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
            padding: const EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width * 0.99,
            child: Text(
              text,
              textDirection:
                  isRTL(text) ? TextDirection.rtl : TextDirection.ltr,
              maxLines: flag ? 50 : 3,
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.black,
              ),
            ),
          ),
          InkWell(
            onTap: onRevealMoreText,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                text.toString().length < 120
                    ? Text(
                        '',
                        style: TextStyle(
                          fontSize: 0.000001,
                        ),
                      )
                    : flag
                        ? Text(
                            '',
                            style: TextStyle(
                              fontSize: 0.000001,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                              bottom: 3.0,
                              top: 0.0,
                              right: 8.0,
                            ),
                            child: Text(
                              appLanguage['more'],
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                          ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              price.toString() != 'null'
                  ? Container(
                      color: Colors.purple,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      child: Text(
                        price,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2.0,
                        ),
                      ),
                    )
                  : const SizedBox(
                      width: 0.0,
                      height: 0.0,
                    ),
            ],
          ),
          images.length > 0
              ? postImages(
                  images: images,
                  context: context,
                  scrollView: imagesScrollView,
                )
              : emptyBox(),
        ],
      ),
    );
  }

  Widget postImages({
    List images,
    context,
    scrollView,
  }) {
    double imagesWidth;
    switch (images.length) {
      case 1:
        imagesWidth = MediaQuery.of(context).size.width * 1;
        break;
      default:
        imagesWidth = MediaQuery.of(context).size.width * 0.7;
        break;
    }
    return Center(
      child: Container(
        height: 280.0,
        child: ListView.builder(
          scrollDirection: scrollView,
          itemCount: images.length,
          itemBuilder: (BuildContext context, int index) {
            if (images[index] != null) {
              return singleImageRenderer(images[index], context, imagesWidth);
            } else
              return emptyBox();
          },
        ),
      ),
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
          InkResponse(
            splashColor: Colors.grey[200],
            radius: 25.0,
            child: Icon(
              FontAwesomeIcons.share,
              color: Colors.grey,
              size: 20,
            ),
            onTap: () {},
          ),
        ],
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
                  FontAwesomeIcons.arrowAltCircleUp,
                  textDirection: TextDirection.rtl,
                  color: Colors.cyan,
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
                  FontAwesomeIcons.arrowAltCircleDown,
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

  Widget renderFullScreenImages({
    images,
    context,
  }) {
    double imagesWidth;
    switch (images.length) {
      case 1:
        imagesWidth = MediaQuery.of(context).size.width * 1;
        break;
      default:
        imagesWidth = MediaQuery.of(context).size.width * 1;
        break;
    }
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 1,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: images.length,
          itemBuilder: (BuildContext context, int index) {
            return singleImageRenderer(images[index], context, imagesWidth);
          },
        ),
      ),
    );
  }
}
