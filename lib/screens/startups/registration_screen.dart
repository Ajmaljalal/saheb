import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../providers/languageProvider.dart';
import '../../providers/authProvider.dart';
import '../../languages/index.dart';
import '../../widgets/errorDialog.dart';
import '../../widgets/circularProgressIndicator.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String _name;
  String _email;
  String _password;
  bool _isRegistering = false;
  bool _isGoogleRegistering = false;
  bool _isFacebookRegistering = false;

  final _formKey = GlobalKey<FormState>();

  void handleNameInputChange(value) {
    _name = value;
  }

  void handleEmailInputChange(value) {
    _email = value;
  }

  void handlePasswordInputChange(value) {
    _password = value;
  }

  onSubmit(appLanguage) async {
    setState(() {
      _isRegistering = true;
    });
    String _userId;
    try {
      _userId = await Provider.of<AuthProvider>(context, listen: false)
          .register(_email, _password, _name);
      if (_userId.length > 0) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (error) {
      var errorMessage = appLanguage['registrationFailed'];
      if (error.toString().contains('ERROR_EMAIL_ALREADY_IN_USE')) {
        errorMessage = appLanguage['inUseEmail'];
      } else if (error.toString().contains('ERROR_INVALID_EMAIL')) {
        errorMessage = appLanguage['invalidEmail'];
      } else if (error.toString().contains('ERROR_WEAK_PASSWORD')) {
        errorMessage = appLanguage['weakPassword'];
      }
      showErrorDialog(
        errorMessage,
        context,
        appLanguage['errorDialogTitle'],
        appLanguage['ok'],
      );
      setState(() {
        _isRegistering = false;
      });
    }
  }

  onGoogleRegistration(appLanguage) async {
    setState(() {
      _isGoogleRegistering = true;
    });

    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .googleSignIn('register');
      Navigator.of(context).pushReplacementNamed('/mainFeeds');
    } catch (error) {
      var errorMessage = appLanguage['registrationFailed'];
      showErrorDialog(
        errorMessage,
        context,
        appLanguage['errorDialogTitle'],
        appLanguage['ok'],
      );
      setState(() {
        _isGoogleRegistering = false;
      });
    }
  }

  onFacebookRegistration(appLanguage) async {
    setState(() {
      _isFacebookRegistering = true;
    });
    var _userId;
    try {
      _userId = await Provider.of<AuthProvider>(context, listen: false)
          .facebookSignIn('register');
      if (_userId.length > 0) {
        Navigator.of(context).pushReplacementNamed('/mainFeeds');
      }
    } catch (error) {
      var errorMessage = appLanguage['registrationFailed'];
      showErrorDialog(
        errorMessage,
        context,
        appLanguage['errorDialogTitle'],
        appLanguage['ok'],
      );
      setState(() {
        _isFacebookRegistering = false;
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
              top: MediaQuery.of(context).size.height * 0.1,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        registrationInputs(
                          appLanguage['name'],
                          _language,
                          handleNameInputChange,
                          appLanguage['enter'],
                          false,
                        ),
                        registrationInputs(
                          appLanguage['email'],
                          _language,
                          handleEmailInputChange,
                          appLanguage['enter'],
                          false,
                        ),
                        registrationInputs(
                          appLanguage['password'],
                          _language,
                          handlePasswordInputChange,
                          appLanguage['enter'],
                          true,
                        ),
                        SizedBox(height: 20),
                        registrationButton(
                            _language, appLanguage, onSubmit, _isRegistering),
                      ],
                    ),
                  ),
                  SizedBox(height: 80),
                  thirdPartyLoginButtons(appLanguage, _language),
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

  Widget registrationInputs(
      String type, String lang, onChange, error, isPassword) {
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
              hintText: type.toUpperCase(),
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
              errorStyle: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
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
              )),
        ),
      ),
    );
  }

  Widget registrationButton(
      String lang, appLanguage, onSubmit, _isRegistering) {
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
              onSubmit(appLanguage);
            } else
              return;
          },
          child: Center(
            child: _isRegistering == true
                ? progressIndicator()
                : Text(
                    lang == 'English' ? 'Register' : appLanguage['register'],
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
          ),
        ),
      ),
    );
  }

  Widget thirdPartyLoginButtons(appLanguage, language) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 10.0,
        ),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  onFacebookRegistration(appLanguage);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: Colors.deepPurpleAccent,
                  ),
                  child: _isFacebookRegistering
                      ? Center(child: progressIndicator())
                      : Row(
                          children: <Widget>[
                            Text(
                              language == 'English'
                                  ? 'Register with'
                                  : appLanguage['registerWithFacebook'],
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
                  onGoogleRegistration(appLanguage);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 15.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: Colors.deepPurpleAccent,
                  ),
                  child: _isGoogleRegistering
                      ? Center(child: progressIndicator())
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              language == 'English'
                                  ? 'Register with'
                                  : appLanguage['registerWithGoogle'],
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
              'Have an account?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/login');
              },
              child: Text(
                'Login',
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
            appLanguage['haveAnAccount'],
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/login');
            },
            padding: EdgeInsets.all(0),
            child: Text(
              appLanguage['login'],
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
