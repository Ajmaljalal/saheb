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
          post['user'],
        ),
        CustomVerticalDivider(),
        userLocationHolder(
          post['userLocation'],
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
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget postContent(text, pictures, flag, onRevealMoreText) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              text,
              maxLines: flag ? 50 : 2,
              style: TextStyle(
                fontSize: 14,
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
                        "نور...",
                        style: TextStyle(color: Colors.deepPurple),
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

  Widget postLikesCommentsCountHolder(likes, comments) {
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
              Text('تبصرې'),
            ],
          ),
          Row(
            children: <Widget>[
              Text(likes.toString()),
              SizedBox(
                width: 2,
              ),
              Text('Likes'),
            ],
          )
        ],
      ),
    );
  }

  Widget postActionButtons(onClickComment) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
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
            onTap: () {},
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
              onClickComment();
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

  Widget individualCommentRenderer(postComments) {
    return Container(
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
//                userNameHolder(postComments[0]['user']),
                commentTextHolder(postComments[0]),
              ],
            ),
          ),
        ],
      ),
    );
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
          topLeft: Radius.circular(40.0),
          bottomRight: Radius.circular(40.0),
          bottomLeft: Radius.circular(40.0),
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
          userNameHolder(postComment['user']),
          Text(
            postComment['commentText'],
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          commentActionButtons(),
        ],
      ),
    );
  }

  Widget commentActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        IconButton(
          icon: Icon(
            FontAwesomeIcons.heart,
            color: Colors.deepPurple,
            size: 20,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            FontAwesomeIcons.trash,
            color: Colors.deepPurple,
            size: 18,
          ),
          onPressed: () {},
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 150),
            Text('5'),
            SizedBox(width: 5),
            Text('Likes'),
          ],
        ),
      ],
    );
  }

  Widget addCommentTextField(focusNode) {
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
          focusNode: focusNode,
          autocorrect: false,
          cursorColor: Colors.black,
          autofocus: false,
          maxLines: null,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            icon: IconButton(
              icon: Icon(
                Icons.arrow_upward,
                color: Colors.deepPurple,
                size: 40,
              ),
              onPressed: () {},
            ),
            contentPadding: kPaddingAll20,
            fillColor: Colors.white,
            labelText: 'پر دې پوسټ څه ولیکئ...',
            labelStyle: TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
            enabledBorder: kOutlineInputBorderGrey,
            focusedBorder: kOutlineInputBorderPurple,
          ),
        ),
      ),
    );
  }
}
