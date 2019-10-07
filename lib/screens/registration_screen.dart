import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:provider/provider.dart';
import '../store/store.dart';
import '../languages/index.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String _name;
  String _email;
  String _password;

  void handleNameInputChange(value) {
    _name = value;
  }

  void handleEmailInputChange(value) {
    _email = value;
  }

  void handlePasswordInputChange(value) {
    _password = value;
  }

  @override
  Widget build(BuildContext context) {
    String _language = Provider.of<Store>(context).getLanguage;
    Map appLanguage = getLanguages(context);
    return ChangeNotifierProvider<Store>(
      builder: (_) => Store(),
      child: Scaffold(
//        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.deepPurple,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              right: 10,
              left: 10,
              top: MediaQuery.of(context).size.height * 0.1,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  registrationInputs(
                    'name',
                    _language,
                    handleEmailInputChange,
                  ),
                  registrationInputs(
                    'email',
                    _language,
                    handleEmailInputChange,
                  ),
                  registrationInputs(
                    'password',
                    _language,
                    handlePasswordInputChange,
                  ),
                  registrationButton(
                    _language,
                    appLanguage,
                    [_name, _email, _password],
                  ),
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

  Widget registrationInputs(String type, String lang, onChange) {
    TextEditingController controller = TextEditingController();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          onChanged: (value) => onChange(value),
          textAlign: TextAlign.center,
          autocorrect: false,
          autofocus: false,
          obscureText: type == 'password' ? true : false,
          keyboardType: TextInputType.emailAddress,
          cursorColor: Colors.white,
//          controller: controller,
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

  Widget registrationButton(String lang, appLanguage, state) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          border: Border.all(
            color: Colors.deepOrange,
            width: 3.0,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: FlatButton(
          onPressed: () {
            print(
              state,
            );
            Navigator.pop(context);
            Navigator.pushNamed(context, '/login');
          },
          child: Center(
            child: Text(
              lang == 'English' ? 'Register' : appLanguage['register'],
              style: TextStyle(fontSize: 30, color: Colors.white),
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
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/login');
            },
            padding: EdgeInsets.all(0),
            child: Text(
              appLanguage['login'],
              style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 25,
              ),
            ),
          ),
          Text(
            appLanguage['haveAnAccount'],
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
        ],
      );
    }
  }
}
