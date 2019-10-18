import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/languageProvider.dart';
import '../languages/index.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _email;
  String _password;

  void handleEmailInputChange(value) {
    _email = value;
  }

  void handlePasswordInputChange(value) {
    _password = value;
    print(_password);
  }

  @override
  Widget build(BuildContext context) {
    String _language = Provider.of<LanguageProvider>(context).getLanguage;
    Map appLanguage = getLanguages(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height * 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).accentColor,
                Theme.of(context).primaryColor,
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              right: 10,
              left: 10,
              top: MediaQuery.of(context).size.height * 0.15,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  loginInputs('email', _language, handleEmailInputChange),
                  loginInputs('password', _language, handlePasswordInputChange),
                  SizedBox(height: 20),
                  loginButton(_language, appLanguage, [_email, _password]),
                  SizedBox(height: 80),
                  thirdPartyLoginButtons(),
                  Center(
                    child: Divider(
                      color: Colors.deepOrange,
                      indent: 50.0,
                      endIndent: 50.0,
                    ),
                  ),
                  Center(child: haveAnAccountText(_language, appLanguage))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget loginInputs(String type, String lang, onChange) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          onChanged: onChange,
          textAlign: TextAlign.center,
          autocorrect: false,
          autofocus: false,
          obscureText: type == 'password' ? true : false,
          keyboardType: TextInputType.emailAddress,
          cursorColor: Colors.white,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontFamily: 'arial',
            letterSpacing: 3,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 20,
              ),
              labelText: type.toUpperCase(),
              labelStyle: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 3.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 3.0,
                ),
              )),
        ),
      ),
    );
  }

  Widget loginButton(String lang, appLanguage, state) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          border: Border.all(
            color: Colors.white,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: FlatButton(
          onPressed: () {
            print(
              state,
            );
            Navigator.pushReplacementNamed(context, '/mainFeeds');
          },
          child: Center(
            child: Text(
              lang == 'English' ? 'Login' : appLanguage['login'],
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget thirdPartyLoginButtons() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('login with Facebook'),
              Text('login with Gmail')
            ],
          ),
        ),
      ),
    );
  }

  Widget haveAnAccountText(lang, appLanguage) {
    if (lang == 'English') {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Do not an account?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/register');
              },
              child: Text(
                'Register',
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 25,
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            appLanguage['doNotHaveAnAccount'],
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/register');
            },
            padding: EdgeInsets.all(0),
            child: Text(
              appLanguage['register'],
              style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 25,
              ),
            ),
          ),
        ],
      );
    }
  }
}
