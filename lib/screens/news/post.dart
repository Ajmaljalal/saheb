import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../store/store.dart';
import '../../widgets/verticalDivider.dart';
import '../../constant_widgets/constants.dart';
import 'postDetails.dart';

class Post extends StatefulWidget {
  final Map<String, dynamic> post;
  Post({Key key, this.post}) : super(key: key);
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  bool revealMoreTextFlag = false;

  _revealMoreText() {
    setState(() {
      revealMoreTextFlag = !revealMoreTextFlag;
    });
  }

  goToDetailsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetails(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return Padding(
      padding: const EdgeInsets.only(top: 3.0),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 1,
          decoration: BoxDecoration(),
          child: ChangeNotifierProvider<Store>(
            builder: (_) => Store(),
            child: Card(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: kSpaceBetween,
                    crossAxisAlignment: kStart,
                    children: <Widget>[
                      cardHeader(post),
                      postTypeHolder(
                        context,
                        post['postType'],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      goToDetailsScreen();
                    },
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            postTittleHolder(post['postTitle']),
                          ],
                        ),
                        postContent(
                          post['postText'],
                          post['postPictures'],
                          revealMoreTextFlag,
                        ),
                      ],
                    ),
                  ),
                  postLikesCommentsCountHolder(
                      post['postLikes'], post['postComments']),
                  kHorizontalDivider,
                  postActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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

  Widget postContent(text, pictures, flag) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              text,
              maxLines: flag ? 20 : 3,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          InkWell(
            onTap: _revealMoreText,
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
      width: double.infinity,
      height: 150,
      child: Scrollbar(
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            singleImageRenderer(
                'https://www.bestfunforall.com/better/imgs/Landscapes%20Nature%20For%20Mobile%20wallpaper%20%204.jpg'),
            singleImageRenderer(
                'https://www.mobilesmspk.net/user/images/wallpaper_images/2013/08/17/www.mobilesmspk.net_beautiful-nature_2521.jpg'),
            singleImageRenderer(
                'http://www.wallpaperg.com/screenshot/filess/1452149070-beautiful-nature-wallpaper-screenshot.jpg'),
          ],
        ),
      ),
    );
  }

  Widget singleImageRenderer(url) {
    return Container(
      width: 150,
      height: 150,
      padding: EdgeInsets.all(5),
      child: Image.network(
        url,
        fit: BoxFit.fill,
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
              Text('3'),
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

  Widget postActionButtons() {
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
              Icons.favorite,
              color: Colors.deepPurple,
              size: 20,
            ),
            onTap: () {},
          ),
          InkResponse(
            splashColor: Colors.grey[200],
            radius: 25.0,
            child: Icon(
              Icons.mode_comment,
              color: Colors.deepPurple,
              size: 20,
            ),
            onTap: () {
              goToDetailsScreen();
            },
          ),
          InkResponse(
            splashColor: Colors.grey[200],
            radius: 25.0,
            child: Icon(
              Icons.share,
              color: Colors.deepPurple,
              size: 20,
            ),
            onTap: () {},
          ),
          InkResponse(
            splashColor: Colors.grey[200],
            radius: 25.0,
            child: Icon(
              Icons.delete,
              color: Colors.deepPurple,
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
}
