import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:saheb/widgets/fullScreenImage.dart';
import '../widgets/verticalDivider.dart';
import '../constant_widgets/constants.dart';
import '../widgets/imageRenderer.dart';

class PostMixin {
  Widget cardHeader(post) {
    return Row(
      children: <Widget>[
        userAvatarHolder(url: post['owner']['photo']),
        userNameHolder(
          post['owner']['name'],
        ),
        CustomVerticalDivider(),
        userLocationHolder(
          post['owner']['location'],
        ),
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

  Widget userNameHolder(userName) {
    return Container(
      child: Text(
        userName,
        style: kUserNameStyle,
      ),
    );
  }

  Widget userLocationHolder(location) {
    return Container(
      child: Text(
        location,
        style: kUserLocationStyle,
      ),
    );
  }

  Widget postTypeHolder(context, postType) {
    if (postType != 'عادی') {
      return Container(
        width: MediaQuery.of(context).size.width * 0.15,
        padding: const EdgeInsets.symmetric(
          horizontal: 3,
          vertical: 2,
        ),
        child: Text(
          postType,
          style: kPostTypeTextStyle,
          textAlign: TextAlign.center,
        ),
        decoration: kAdvertTypeBoxDecoration,
      );
    } else
      return Text('');
  }

  Widget postTittleHolder(title) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 10.0,
        left: 10.0,
      ),
      child: Container(
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
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
  }) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              text,
              maxLines: flag ? 50 : 2,
              style: TextStyle(
                fontSize: 16,
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
              : SizedBox(
                  height: 0.0,
                ),
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
            return singleImageRenderer(images[index], context, imagesWidth);
          },
        ),
      ),
    );
  }

  Widget postLikesCommentsCountHolder({
    post,
    appLanguage,
    userId,
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
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                commentsHolderText.toString(),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text(likes.toString()),
              SizedBox(
                width: 5,
              ),
              Icon(
                FontAwesomeIcons.heart,
                size: 15.0,
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
    onDeletePost,
    context,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkResponse(
            splashColor: Colors.grey[200],
            radius: 25.0,
            child: Icon(
              FontAwesomeIcons.thumbsUp,
              color: Colors.grey,
              size: 20,
            ),
            onTap: () {
              updateLikes(context);
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
          SizedBox(
            width: 80.0,
          ),
          flag == 'details'
              ? Text('Details')
              : InkResponse(
                  splashColor: Colors.grey[200],
                  radius: 25.0,
                  child: Icon(
                    userId == post['owner']['id']
                        ? Icons.delete_outline
                        : Icons.remove_red_eye,
                    color: Colors.grey,
                    size: 20,
                  ),
                  onTap: () async {
                    if (userId == post['owner']['id']) {
                      await onDeletePost(context);
                    } else {
                      return;
                    }
                  },
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
  }) {
    return comments.map((comment) {
      return Container(
        child: Container(
          child: Row(
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget commentTextHolder({
    postComment,
    likeComment,
    deleteComment,
    userId,
    postOwnerId,
  }) {
    return Container(
      width: 330,
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
          userNameHolder(postComment['user']['name']),
          Text(
            postComment['text'],
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'ZarReg',
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
                await likeComment(comment);
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
            Text(comment['likes'].toString()),
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
//      height: 50.0,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            //                    <--- top side
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
                  textDirection: TextDirection.ltr,
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
