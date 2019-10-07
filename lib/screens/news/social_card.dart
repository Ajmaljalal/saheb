import 'package:flutter/material.dart';
import '../../widgets/verticalDivider.dart';

class SocialCard extends StatelessWidget {
  final user;

  SocialCard({this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                    postTittle('یخچال های مستعمل'),
                  ],
                ),
                postContent(
                  'ما یخچال های مستعمل داریم هر کس می خواهد به شماره ما تماس بیګرد. یخچال های ما دوباره سازی شده و به هیچ صورت خراب نیستند.',
                  'pictures',
                ),
              ],
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

  Widget postTittle(title) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Container(
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
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
                fontSize: 12,
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
            Container(
              width: 150,
              height: 150,
              padding: EdgeInsets.all(5),
              child: Image.network(
                'https://i5.walmartimages.com/asr/f5ff235b-e8a1-43b2-9bdb-8c732f9aaf1e_1.f209c79538c434a484f5847f039dcc06.jpeg',
                fit: BoxFit.fill,
              ),
            ),
            Container(
              width: 150,
              height: 150,
              padding: EdgeInsets.all(5),
              child: Image.network(
                'https://i5.walmartimages.ca/images/Large/006/6_1/999999-840826150066_1.jpg',
                fit: BoxFit.fill,
              ),
            ),
            Container(
              width: 150,
              height: 150,
              padding: EdgeInsets.all(5),
              child: Image.network(
                'https://images-na.ssl-images-amazon.com/images/I/51OHbt34-AL._SX522_.jpg',
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
