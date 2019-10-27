import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../providers/languageProvider.dart';
import '../../providers/authProvider.dart';
import '../../languages/index.dart';
import '../../widgets/errorDialog.dart';
import '../../widgets/circularProgressIndicator.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _email;
  String _password;
  bool _isLoggingIn = false;
  bool _isGoogleLogingIn = false;
  bool _isFacebookLogingIn = false;

  final _formKey = GlobalKey<FormState>();

  void handleEmailInputChange(value) {
    _email = value;
  }

  void handlePasswordInputChange(value) {
    _password = value;
  }

  Future<void> onLogin(appLanguage) async {
    setState(() {
      _isLoggingIn = true;
    });

    try {
      await Provider.of<AuthProvider>(context).login(_email, _password);
//      if (_user.length > 0) {
//        Navigator.pushReplacementNamed(context, '/mainFeeds');
//      }
    } catch (error) {
      var errorMessage = appLanguage['loginFailed'];
      if (error.toString().contains('ERROR_WRONG_PASSWORD')) {
        errorMessage = appLanguage['wrongPassword'];
      } else if (error.toString().contains('ERROR_USER_NOT_FOUND')) {
        errorMessage = appLanguage['userNotFound'];
      } else if (error.toString().contains('ERROR_INVALID_EMAIL')) {
        errorMessage = appLanguage['invalidEmail'];
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = appLanguage['wrongPassword'];
      }
      showErrorDialog(
        errorMessage,
        context,
        appLanguage['errorDialogTitle'],
        appLanguage['ok'],
      );
      setState(() {
        _isLoggingIn = false;
      });
    }
  }

  Future<void> onGoogleLogin(appLanguage) async {
    setState(() {
      _isGoogleLogingIn = true;
    });
    try {
      await Provider.of<AuthProvider>(context).googleSignIn('login');
    } catch (error) {
      var errorMessage = appLanguage['loginFailed'];
      showErrorDialog(
        errorMessage,
        context,
        appLanguage['errorDialogTitle'],
        appLanguage['ok'],
      );
      setState(() {
        _isGoogleLogingIn = false;
      });
    }
  }

  Future<void> onFacebookLogIn(appLanguage) async {
    setState(() {
      _isFacebookLogingIn = true;
    });
    var _userId;
    try {
      _userId =
          await Provider.of<AuthProvider>(context).facebookSignIn('login');
//      if (_userId.length > 0) {
//        Navigator.of(context).pushReplacementNamed('/mainFeeds');
//      }
    } catch (error) {
      var errorMessage = appLanguage['loginFailed'];
      showErrorDialog(
        errorMessage,
        context,
        appLanguage['errorDialogTitle'],
        appLanguage['ok'],
      );
      setState(() {
        _isFacebookLogingIn = false;
      });
    }
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
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        loginInputs(
                          appLanguage['email'],
                          _language,
                          handleEmailInputChange,
                          appLanguage['enter'],
                          false,
                        ),
                        loginInputs(
                          appLanguage['password'],
                          _language,
                          handlePasswordInputChange,
                          appLanguage['enter'],
                          true,
                        ),
                        SizedBox(height: 20),
                        loginButton(_language, appLanguage, onLogin),
                      ],
                    ),
                  ),
                  SizedBox(height: 80),
                  thirdPartyLoginButtons(appLanguage, _language, onGoogleLogin),
                  Center(
                    child: Divider(
                      color: Colors.white,
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

  Widget loginInputs(String type, String lang, onChange, error, isPassword) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 2.0,
          horizontal: 15.0,
        ),
        child: TextFormField(
          onChanged: onChange,
          validator: (value) {
            String errorText = lang == 'English' ? 'Enter ' : error;
            if (value.isEmpty) {
              return '$type $errorText';
            }
            return null;
          },
          textAlign: TextAlign.center,
          autocorrect: false,
          obscureText: isPassword,
          keyboardType: TextInputType.emailAddress,
          cursorColor: Colors.black,
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            letterSpacing: 3,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 20,
            ),
            errorStyle: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
            hintText: type.toUpperCase(),
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 20,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Colors.cyan,
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Colors.white,
                width: 2.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButton(String lang, appLanguage, onLogin) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 20.0,
      ),
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
            if (_formKey.currentState.validate()) {
              onLogin(appLanguage);
            } else
              return;
          },
          child: Center(
            child: _isLoggingIn == true
                ? progressIndicator()
                : Text(
                    lang == 'English' ? 'Login' : appLanguage['login'],
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
          ),
        ),
      ),
    );
  }

  Widget thirdPartyLoginButtons(appLanguage, language, onGoogleLogin) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 20.0,
        ),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  onFacebookLogIn(appLanguage);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.41,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: Colors.deepPurpleAccent,
                  ),
                  child: _isFacebookLogingIn
                      ? Center(child: progressIndicator())
                      : Row(
                          children: <Widget>[
                            Text(
                              language == 'English'
                                  ? 'Sign in with'
                                  : appLanguage['signinWithFacebook'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Icon(
                              FontAwesomeIcons.facebook,
                              color: Colors.white,
                            )
                          ],
                        ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  onGoogleLogin(appLanguage);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.41,
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 15.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: Colors.deepPurpleAccent,
                  ),
                  child: _isGoogleLogingIn
                      ? Center(child: progressIndicator())
                      : Row(
                          children: <Widget>[
                            Text(
                              language == 'English'
                                  ? 'Sign in with'
                                  : appLanguage['signinWithGoogle'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Icon(
                              FontAwesomeIcons.google,
                              color: Colors.white,
                            )
                          ],
                        ),
                ),
              ),
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
                  color: Colors.white,
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
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
        ],
      );
    }
  }
}
