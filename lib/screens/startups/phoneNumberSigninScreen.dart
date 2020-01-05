import 'package:com.pywast.pywast/widgets/emptyBox.dart';
import 'package:flutter/material.dart';
import '../../languages/index.dart';

class PhoneNumberSignIn extends StatefulWidget {
  final isLoginScreen;
  final isCodeSent;
  final onSmsCodeInputChanged;
  PhoneNumberSignIn({
    this.isLoginScreen,
    this.isCodeSent,
    this.onSmsCodeInputChanged,
  });
  @override
  _PhoneNumberSignInState createState() => _PhoneNumberSignInState();
}

class _PhoneNumberSignInState extends State<PhoneNumberSignIn> {
  @override
  Widget build(BuildContext context) {
    final appLanguage = getLanguages(context);
    return Container(
        child: TextFormField(
      onChanged: widget.onSmsCodeInputChanged,
      autofocus: true,
      decoration: InputDecoration(
        hintText: appLanguage['code'],
        hintStyle: TextStyle(
          fontFamily: 'Muna',
        ),
      ),
    ));
  }
}