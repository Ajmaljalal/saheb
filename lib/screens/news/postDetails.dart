import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../widgets/verticalDivider.dart';

class PostDetails extends StatefulWidget {
  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Details')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(),
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          cardHeader(),
                          postTypeHolder(context),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          postTittleHolder('یخچال های مستعمل'),
                        ],
                      ),
                      postContent(
                        'ما یخچال های مستعمل داریم هر کس می خواهد به شماره ما تماس بیګرد. یخچال های ما دوباره سازی شده و به هیچ صورت خراب نیستند. یخچال های ما دوباره سازی شده و به هیچ صورت خراب نیستند. یخچال های ما دوباره سازی شده و به هیچ صورت خراب نیستند. یخچال های ما دوباره سازی شده و به هیچ صورت خراب نیستند. یخچال های ما دوباره سازی شده و به هیچ صورت خراب نیستند. یخچال های ما دوباره سازی شده و به هیچ صورت خراب نیستند. یخچال های ما دوباره سازی شده و به هیچ صورت خراب نیستند.',
                        'pictures',
                      ),
                      postLikesCommentsCountHolder(),
                      Divider(
                        color: Colors.grey,
                        height: 1,
                      ),
                      postActionButtons(),
                      Divider(
                        color: Colors.grey,
                        height: 1,
                      ),
                      postCommentsHolder(
                          'بسیار زیبا است ممنون تان. ډېر ښایسته دی آفرین شه. تکړه شی نور شیان هم جوړ کړی. ډېر ښایسته دی آفرین شه. تکړه شی نور شیان هم جوړ کړی. ډېر ښایسته دی آفرین شه. تکړه شی نور شیان هم جوړ کړی.'),
                      postCommentsHolder(
                          'مقبول است اما یګان نقص دارد سرش بیشتر کار کن.'),
                      postCommentsHolder(
                          'ډېر ښایسته دی آفرین شه. تکړه شی نور شیان هم جوړ کړی. ډېر ښایسته دی آفرین شه. تکړه شی نور شیان هم جوړ کړی. ډېر ښایسته دی آفرین شه. تکړه شی نور شیان هم جوړ کړی.'),
                      postCommentsHolder(
                          'چندان چیزی جور نه کدین حیف وقت تان که سری ای اپلیکشن ضایع کردین.'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget cardHeader() {
    return Row(
      children: <Widget>[
        imageRenderer(),
        userNameHolder(),
        CustomVerticalDivider(),
        userLocationHolder(),
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

  Widget userNameHolder() {
    return Container(
      child: Text(
        'اجمل جلال',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget userLocationHolder() {
    return Container(
      child: Text(
        'دریم بلاک، ۱۲ ناحیه',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget postTypeHolder(context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.15,
      padding: EdgeInsets.symmetric(
        horizontal: 3,
        vertical: 2,
      ),
      child: Text(
        'اعلان',
        style: TextStyle(fontSize: 12, color: Colors.white),
        textAlign: TextAlign.center,
      ),
      decoration: BoxDecoration(
        color: Colors.deepOrange,
        border: Border.all(
          color: Colors.deepOrange,
          width: 1,
        ),
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10), topLeft: Radius.circular(5)),
      ),
    );
  }

  Widget postTittleHolder(title) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Container(
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget postContent(text, pictures) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          postImages(),
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

  Widget postLikesCommentsCountHolder() {
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
              Text('15'),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.deepPurple,
              size: 20,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.mode_comment,
              color: Colors.deepPurple,
              size: 20,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.deepPurple,
              size: 20,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.deepPurple,
              size: 20,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget postCommentsHolder(text) {
    return individualCommentRenderer(text);
  }

  Widget individualCommentRenderer(text) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: imageRenderer(),
          ),
          Container(
            margin: EdgeInsets.only(top: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                userNameHolder(),
                commentReplyHolder(text),
                commentActionButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget commentReplyHolder(text) {
    return Container(
      width: 330,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
        ),
      ),
      padding: EdgeInsets.all(10.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }

  Widget commentActionButtons() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            focusColor: Colors.white70,
            icon: Icon(
              Icons.favorite,
              color: Colors.deepPurple,
              size: 20,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.deepPurple,
              size: 20,
            ),
            onPressed: () {},
          ),
          SizedBox(width: 50),
          Text('5'),
          SizedBox(width: 5),
          Text('Likes'),
        ],
      ),
    );
  }
}
