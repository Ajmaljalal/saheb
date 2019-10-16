import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  String postType = '';

  onSelectPostType(value) {
    setState(() {
      postType = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            top: 30.0,
          ),
          child: Column(
            children: <Widget>[
              Text(
                'در باره چه می خواهید بنویسید؟',
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/advertPost');
                },
                child: RadioListTile(
                  subtitle:
                      Text('مثلاً در باره حوادث عادی از محل بود و باش شما.'),
                  isThreeLine: false,
                  title: Text(
                    'عمومی',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  value: 'general',
                  groupValue: postType,
                  onChanged: (value) {
                    onSelectPostType(value);
                    Navigator.pushNamed(context, '/advertPost');
                  },
                  activeColor: Colors.deepPurple,
                ),
              ),
              RadioListTile(
                subtitle: Text(
                    'مثلاً می خواهید چیزی بخرید، بفروشید و یا به کراه دهید.'),
                isThreeLine: false,
                title: Text(
                  'تجارتی',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                value: 'advertPost',
                groupValue: postType,
                onChanged: (value) {
                  onSelectPostType(value);
                  Navigator.pushNamed(context, '/advertPost');
                },
                activeColor: Colors.deepPurple,
              ),
              RadioListTile(
                subtitle: Text(
                    'مثلاً به خون ضرورت است، راه بند است، و حوادث امنیتی.'),
                isThreeLine: false,
                title: Text(
                  'عاجل',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                value: 'urgent',
                groupValue: postType,
                onChanged: (value) {
                  onSelectPostType(value);
                  Navigator.pushNamed(context, '/advertPost');
                },
                activeColor: Colors.deepPurple,
              ),
              RadioListTile(
                subtitle: Text('مثلاً چیزی یا شخصی مفقود ګردیده.'),
                isThreeLine: false,
                title: Text(
                  'مفقودی',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                value: 'lost',
                groupValue: postType,
                onChanged: (value) {
                  onSelectPostType(value);
                  Navigator.pushNamed(context, '/advertPost');
                },
                activeColor: Colors.deepPurple,
              ),
              RadioListTile(
                subtitle: Text('مثلاً چیزی یا شخصی دریافت ګردیده.'),
                isThreeLine: false,
                title: Text(
                  'دریافتی',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                value: 'found',
                groupValue: postType,
                onChanged: (value) {
                  onSelectPostType(value);
                  Navigator.pushNamed(context, '/advertPost');
                },
                activeColor: Colors.deepPurple,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
