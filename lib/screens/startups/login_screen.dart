import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../screens/startups/phoneNumberSigninScreen.dart';
import '../../widgets/emptyBox.dart';
import '../../widgets/emptySpace.dart';
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
  String _name;
  String _email;
  String _password;
  bool _isLoggingIn = false;
  bool _isGoogleLoginIn = false;
  bool _isFacebookLoginIn = false;
  String _phoneNo;
  String _smsCode;
  String _verificationId;
  String _screen = 'login';
  bool _isPhoneSignIn = false;
  final _formKey = GlobalKey<FormState>();

  void handleNameInputChange(value) {
    _name = value.toString().trim();
  }

  void handlePhoneNoInputChange(value) {
    setState(() {
      _phoneNo = value.toString().trim();
    });
  }

  void handleSmsCodeInputChange(value) {
    setState(() {
      _smsCode = value.toString().trim();
    });
  }

  void handleEmailInputChange(value) {
    _email = value.toString().trim();
  }

  void handlePasswordInputChange(value) {
    _password = value.toString().trim();
  }

  void swapScreensBetweenSignInAndRegister() {
    if (_screen == 'login') {
      setState(() {
        _screen = 'register';
      });
    } else {
      setState(() {
        _screen = 'login';
      });
    }
  }

  void swapScreenToPhoneSignIn() {
    setState(() {
      _isPhoneSignIn = !_isPhoneSignIn;
    });
  }

  Future<void> onRegisterWithEmailAndPassword(appLanguage) async {
    setState(() {
      _isLoggingIn = true;
    });
    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .register(_email, _password, _name, context);
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
        _isLoggingIn = false;
      });
    }
  }

  Future<void> onEmailAndPasswordLogin(appLanguage) async {
    setState(() {
      _isLoggingIn = true;
    });
    try {
      await Provider.of<AuthProvider>(context).login(
        _email,
        _password,
      );
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
      _isGoogleLoginIn = true;
    });
    try {
      await Provider.of<AuthProvider>(context)
          .googleSignIn(_screen == 'login' ? 'login' : 'register', context);
    } catch (error) {
      var errorMessage = appLanguage['loginFailed'];
      showErrorDialog(
        errorMessage,
        context,
        appLanguage['errorDialogTitle'],
        appLanguage['ok'],
      );
      setState(() {
        _isGoogleLoginIn = false;
      });
    }
  }

  Future<void> onFacebookLogIn(appLanguage) async {
    setState(() {
      _isFacebookLoginIn = true;
    });
    try {
      await Provider.of<AuthProvider>(context)
          .facebookSignIn(_screen == 'login' ? 'login' : 'register', context);
    } catch (error) {
      var errorMessage = appLanguage['loginFailed'];
      showErrorDialog(
        errorMessage,
        context,
        appLanguage['errorDialogTitle'],
        appLanguage['ok'],
      );
      setState(() {
        _isFacebookLoginIn = false;
      });
    }
  }

  Future<void> verifyPhone(appLanguage) async {
    setState(() {
      _isLoggingIn = true;
    });
    try {
      String phoneNumber = _phoneNo;
      if (_phoneNo.toString().startsWith('0')) {
        phoneNumber = '+93${_phoneNo.substring(1)}';
      } else {
        phoneNumber = '+93$_phoneNo';
      }
      final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
        setState(() {
          this._verificationId = verId;
        });
      };
      final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
        setState(() {
          this._verificationId = verId;
        });
        enterCodeDialog(appLanguage);
      };
      final PhoneVerificationCompleted success = (AuthCredential user) {
        print('verified');
      };
      final PhoneVerificationFailed failed = (AuthException exception) {
        if (exception.message
            .contains('The format of the phone number provided is incorrect')) {
          showErrorDialog(
            appLanguage['invalidPhoneNo'],
            context,
            appLanguage['errorDialogTitle'],
            appLanguage['ok'],
          );
        } else {
          showErrorDialog(
            appLanguage['phoneSignInError'],
            context,
            appLanguage['errorDialogTitle'],
            appLanguage['ok'],
          );
        }
      };
      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 0),
          verificationCompleted: success,
          verificationFailed: failed,
          codeSent: smsCodeSent,
          codeAutoRetrievalTimeout: autoRetrieve,
        );
      } catch (error) {
        throw error;
      }
    } catch (error) {
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    String _language = Provider.of<LanguageProvider>(context).getLanguage;
    double fontSize = _language == 'English' ? 13.0 : 15.0;
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
              top: MediaQuery.of(context).size.height * 0.13,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  signInForm(
                    appLanguage,
                    _language,
                    fontSize,
                  ),
                  const EmptySpace(height: 70.0),
                  loginButton(
                    appLanguage,
                    swapScreenToPhoneSignIn,
                    fontSize,
                    'phoneAuth',
                  ),
                  const EmptySpace(height: 10.0),
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
                  haveAnAccountText(
                    _language,
                    appLanguage,
                    fontSize,
                    swapScreensBetweenSignInAndRegister,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Form signInForm(
    Map appLanguage,
    String _language,
    double fontSize,
  ) {
    final onClickForEmailAndPassword = _screen == 'login'
        ? onEmailAndPasswordLogin
        : onRegisterWithEmailAndPassword;
    return !_isPhoneSignIn
        ? Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _screen == 'register'
                    ? loginInputs(
                        appLanguage['name'],
                        _language,
                        handleNameInputChange,
                        appLanguage['enter'],
                        false,
                        fontSize,
                        false,
                      )
                    : emptyBox(),
                loginInputs(
                  appLanguage['email'],
                  _language,
                  handleEmailInputChange,
                  appLanguage['enter'],
                  false,
                  fontSize,
                  false,
                ),
                loginInputs(
                  appLanguage['password'],
                  _language,
                  handlePasswordInputChange,
                  appLanguage['enter'],
                  true,
                  fontSize,
                  false,
                ),
                const EmptySpace(height: 10.0),
                loginButton(
                  appLanguage,
                  onClickForEmailAndPassword,
                  fontSize,
                  'notPhoneAuth',
                ),
              ],
            ),
          )
        : Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                loginInputs(
                  appLanguage['name'],
                  _language,
                  handleNameInputChange,
                  appLanguage['enter'],
                  false,
                  fontSize,
                  false,
                ),
                loginInputs(
                  appLanguage['phoneNumber'],
                  _language,
                  handlePhoneNoInputChange,
                  appLanguage['enter'],
                  false,
                  fontSize,
                  true,
                ),
                const EmptySpace(height: 10.0),
                loginButton(
                  appLanguage,
                  verifyPhone,
                  fontSize,
                  'notPhoneAuth',
                ),
              ],
            ),
          );
  }

  Widget loginInputs(
    String type,
    String lang,
    onChange,
    error,
    isPassword,
    fontSize,
    isPhone,
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
          textAlign: isPhone ? TextAlign.left : TextAlign.center,
          textDirection: TextDirection.ltr,
          autocorrect: false,
          obscureText: isPassword,
          keyboardType:
              isPhone ? TextInputType.phone : TextInputType.emailAddress,
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
            suffixText: isPhone ? '0093' : '',
            suffixStyle: TextStyle(
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

  Widget loginButton(
    appLanguage,
    onClick,
    fontSize,
    action,
  ) {
    final isLoginScreen = _screen == 'login' ? true : false;
    final isPhoneLogin = action == 'phoneAuth' ? true : false;
    final loginWithPhoneButtonText = !_isPhoneSignIn
        ? appLanguage['signinWithPhone']
        : appLanguage['signinWithEmail'];
    final loginOrRegisterButtonText =
        isLoginScreen ? appLanguage['login'] : appLanguage['register'];
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        height: 45,
        decoration: BoxDecoration(
          color: !isPhoneLogin ? Theme.of(context).accentColor : Colors.purple,
          border: Border.all(
            color: Colors.white,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: FlatButton(
          onPressed: () async {
            if (!isPhoneLogin) {
              if (_formKey.currentState.validate()) {
                await onClick(appLanguage);
              } else
                return;
            } else {
              await onClick();
            }
          },
          child: Center(
            child: isPhoneLogin
                ? Text(
                    loginWithPhoneButtonText,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  )
                : _isLoggingIn == true
                    ? circularProgressIndicator()
                    : Text(
                        loginOrRegisterButtonText,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
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
                  child: _isFacebookLoginIn
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
                  child: _isGoogleLoginIn
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

  Widget haveAnAccountText(
    lang,
    appLanguage,
    fontSize,
    swapScreens,
  ) {
    if (lang == 'English') {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _screen == 'login'
                  ? appLanguage['doNotHaveAnAccount']
                  : appLanguage['haveAnAccount'],
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
              ),
            ),
            Container(
              width: _screen == 'register' ? 80.0 : 97.0,
              child: FlatButton(
                onPressed: () {
                  swapScreens();
                },
                child: Text(
                  _screen == 'login'
                      ? appLanguage['register']
                      : appLanguage['login'],
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
            _screen == 'login'
                ? appLanguage['doNotHaveAnAccount']
                : appLanguage['haveAnAccount'],
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
            ),
          ),
          Container(
            width: _screen == 'register' ? 40.0 : 80.0,
            child: FlatButton(
              onPressed: () {
                swapScreens();
              },
              padding: const EdgeInsets.all(0),
              child: Text(
                _screen == 'login'
                    ? appLanguage['register']
                    : appLanguage['login'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  enterCodeDialog(appLanguage) {
    final isLoginScreen = _screen == 'login' ? true : false;
    final actionType = isLoginScreen ? ' login' : 'register';
    Alert(
      context: context,
      title: appLanguage['enterPasscode'],
      style: const AlertStyle(
        titleStyle: const TextStyle(
          fontSize: 20.0,
          color: Colors.black,
        ),
        isCloseButton: false,
      ),
      content: PhoneNumberSignIn(
        onSmsCodeInputChanged: handleSmsCodeInputChange,
      ),
      buttons: [
        DialogButton(
          color: Colors.purple,
          onPressed: () {
            if (_phoneNo == null || _phoneNo.trim().length == 0) {
              return;
            }
            if (_name == null || _name.trim().length == 0) {
              return;
            }
            Provider.of<AuthProvider>(context)
                .signInWithPhone(
              verificationId: _verificationId,
              smsCode: _smsCode,
              userName: _name,
              actionType: actionType,
              context: context,
            )
                .then((value) {
              if (value == false) {
                showErrorDialog(
                  appLanguage['invalidPasscode'],
                  context,
                  appLanguage['errorDialogTitle'],
                  appLanguage['ok'],
                );
                return;
              } else {
                setState(() {
                  _isLoggingIn = true;
                });
                Navigator.of(context).pop();
              }
            }).catchError((error) {
              print('error');
            });
          },
          child: Text(
            appLanguage['login'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      ],
    ).show();
  }
}
