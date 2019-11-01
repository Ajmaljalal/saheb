import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/verticalDivider.dart';
import '../constant_widgets/constants.dart';
import '../widgets/imageRenderer.dart';

class PostMixin {
  Widget cardHeader(post) {
    return Row(
      children: <Widget>[
        imageRenderer(),
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

  Widget imageRenderer() {
    return Container(
      width: 60.0,
      height: 60.0,
      padding: EdgeInsets.all(10),
      child: CircleAvatar(
          backgroundImage: NetworkImage(
        'https://cdn.pixabay.com/photo/2014/03/24/17/19/teacher-295387_1280.png',
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
        padding: EdgeInsets.symmetric(
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
      padding: const EdgeInsets.only(right: 10.0),
      child: Container(
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            fontFamily: 'ZarReg',
          ),
        ),
      ),
    );
  }

  Widget postContent(text, pictures, flag, onRevealMoreText, appLanguage) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              text,
              maxLines: flag ? 50 : 2,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'ZarReg',
                color: Colors.black,
              ),
            ),
          ),
          InkWell(
            onTap: onRevealMoreText,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                flag
                    ? Text('')
                    : Text(
                        appLanguage['more'],
                        style: TextStyle(color: Colors.blueAccent),
                      ),
              ],
            ),
          ),
          postImages()
        ],
      ),
    );
  }

  Widget postImages() {
    return Container(
      height: 150,
      child: Scrollbar(
        child: Align(
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              singleImageRenderer(
                  'https://www.bestfunforall.com/better/imgs/Landscapes%20Nature%20For%20Mobile%20wallpaper%20%204.jpg'),
              singleImageRenderer(
                  'https://www.mobilesmspk.net/user/images/wallpaper_images/2013/08/17/www.mobilesmspk.net_beautiful-nature_2521.jpg'),
            ],
          ),
        ),
      ),
    );
  }

  Widget postLikesCommentsCountHolder(post, appLanguage) {
    final comments = post['comments'];
    final likes = post['likes'];
    final String commentsHolderText = comments.length > 1
        ? appLanguage['multiComments']
        : appLanguage['singleComment'];
    return Container(
      padding: EdgeInsets.symmetric(
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

  Widget postActionButtons(onClickComment, String postId, String postTitle,
      flag, updateLikes, context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          InkResponse(
            splashColor: Colors.grey[200],
            radius: 25.0,
            child: Icon(
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
          InkResponse(
            splashColor: Colors.grey[200],
            radius: 25.0,
            child: Icon(
              FontAwesomeIcons.ban,
              color: Colors.grey,
              size: 20,
            ),
            onTap: () {
              print('delete clicked');
            },
          ),
        ],
      ),
    );
  }

  //////////////// POST DETAILS SCREEN////////////////////
  ///////////////////////////////////////////////////////

  List individualCommentRenderer(postComments) {
    return postComments.map((comment) {
      return Container(
        child: Container(
          child: Row(
//        crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: imageRenderer(),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0, bottom: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    commentTextHolder(comment),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget commentTextHolder(postComment) {
    return Container(
      width: 330,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300],
          width: 1.5,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
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
          commentActionButtons(postComment['likes']),
        ],
      ),
    );
  }

  Widget commentActionButtons(postLikes) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        IconButton(
          icon: Icon(
            FontAwesomeIcons.thumbsUp,
            color: Colors.cyan,
            size: 18,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            Icons.delete_outline,
            color: Colors.cyan,
            size: 19,
          ),
          onPressed: () {},
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 150),
            Text(postLikes.toString()),
            SizedBox(width: 5),
            Icon(
              FontAwesomeIcons.heart,
              size: 18.0,
            ),
          ],
        ),
      ],
    );
  }

  Widget addCommentTextField({focusNode, appLanguage, onChange, onSubmit}) {
    final TextEditingController _controller = new TextEditingController();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset.zero,
            blurRadius: 5.0,
          ),
        ],
        borderRadius: kBorderRadiusTopT10,
      ),
      child: Padding(
        padding: kPaddingAll8,
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
            icon: IconButton(
              icon: Icon(
                FontAwesomeIcons.arrowAltCircleUp,
                textDirection: TextDirection.ltr,
                color: Colors.cyan,
                size: 35,
              ),
              onPressed: () {
                onSubmit();
                _controller.clear();
              },
            ),
            contentPadding: kPaddingAll10_15,
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
    );
  }
}
