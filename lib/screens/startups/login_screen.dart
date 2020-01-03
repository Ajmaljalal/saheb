import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../screens/startups/registration_screen.dart';
import '../../providers/languageProvider.dart';
import '../../providers/authProvider.dart';
import '../../languages/index.dart';
import '../../widgets/errorDialog.dart';
import '../../widgets/progressIndicators.dart';

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
  String screen = 'login';

  final _formKey = GlobalKey<FormState>();

  void handleEmailInputChange(value) {
    _email = value.toString().trim();
  }

  void handlePasswordInputChange(value) {
    _password = value.toString().trim();
  }

  void swapScreens() {
    if (screen == 'login') {
      setState(() {
        screen = 'register';
      });
    } else {
      setState(() {
        screen = 'login';
      });
    }
  }

  Future<void> onLogin(appLanguage) async {
    setState(() {
      _isLoggingIn = true;
    });

    try {
      await Provider.of<AuthProvider>(context).login(_email, _password);
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
    try {
      await Provider.of<AuthProvider>(context).facebookSignIn('login');
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
    double fontSize = _language == 'English' ? 13.0 : 15.0;
    Map appLanguage = getLanguages(context);
    return screen == 'login'
        ? Scaffold(
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
                    top: MediaQuery.of(context).size.height * 0.13,
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
                                fontSize,
                              ),
                              loginInputs(
                                appLanguage['password'],
                                _language,
                                handlePasswordInputChange,
                                appLanguage['enter'],
                                true,
                                fontSize,
                              ),
                              const SizedBox(height: 20),
                              loginButton(
                                  _language, appLanguage, onLogin, fontSize),
                            ],
                          ),
                        ),
                        const SizedBox(height: 80),
                        thirdPartyLoginButtons(
                          appLanguage,
                          _language,
                          onGoogleLogin,
                          fontSize,
                        ),
                        const Center(
                          child: const Divider(
                            color: Colors.white,
                            indent: 45.0,
                            endIndent: 45.0,
                          ),
                        ),
                        Center(
                          child: haveAnAccountText(
                            _language,
                            appLanguage,
                            fontSize,
                            swapScreens,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : Registration(swapScreens);
  }

  Widget loginInputs(
    String type,
    String lang,
    onChange,
    error,
    isPassword,
    fontSize,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 2.0,
          horizontal: 15.0,
        ),
        child: TextFormField(
          onChanged: onChange,
          validator: (value) {
            String errorText = error;
            if (value.isEmpty) {
              return lang == 'English'
                  ? '$errorText $type'
                  : '$type $errorText';
            }
            return null;
          },
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          autocorrect: false,
          obscureText: isPassword,
          keyboardType: TextInputType.emailAddress,
          cursorColor: Colors.black,
          style: TextStyle(
            color: Colors.black,
            fontSize: fontSize,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            errorStyle: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
            ),
            hintText: type,
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: fontSize,
              fontFamily: lang != 'English' ? 'Muna' : '',
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Colors.cyan,
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 2.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButton(String lang, appLanguage, onLogin, fontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        height: 50,
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
                ? circularProgressIndicator()
                : Text(
                    appLanguage['login'],
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
          ),
        ),
      ),
    );
  }

  Widget thirdPartyLoginButtons(
    appLanguage,
    language,
    onGoogleLogin,
    fontSize,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
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
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: Colors.deepPurpleAccent,
                  ),
                  child: _isFacebookLogingIn
                      ? Center(child: circularProgressIndicator())
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              appLanguage['signinWithFacebook'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: fontSize,
                              ),
                            ),
                            const SizedBox(
                              width: 4.0,
                            ),
                            const Icon(
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
                  width: MediaQuery.of(context).size.width * 0.40,
                  padding: EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: Colors.deepPurpleAccent,
                  ),
                  child: _isGoogleLogingIn
                      ? Center(child: circularProgressIndicator())
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              appLanguage['signinWithGoogle'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: fontSize,
                              ),
                            ),
                            const SizedBox(
                              width: 4.0,
                            ),
                            const Icon(
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

  Widget haveAnAccountText(lang, appLanguage, fontSize, swapScreens) {
    if (lang == 'English') {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              appLanguage['doNotHaveAnAccount'],
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
              ),
            ),
            Container(
              width: 100.0,
              child: FlatButton(
                onPressed: () {
                  swapScreens();
                },
                child: Text(
                  appLanguage['register'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                  ),
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
              fontSize: fontSize,
            ),
          ),
          FlatButton(
            onPressed: () {
              swapScreens();
            },
            padding: const EdgeInsets.all(0),
            child: Text(
              appLanguage['register'],
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
              ),
            ),
          ),
        ],
      );
    }
  }
}
