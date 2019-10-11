import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:saheb/screens/news/postDetails.dart';
import './store/store.dart';
import './screens/login_screen.dart';
//import './screens/language_screen.dart';
import './screens/registration_screen.dart';
import './screens/main__screen.dart';
import './screens/news/postDetails.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Store>(
      builder: (_) => Store(),
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String _language = Provider.of<Store>(context).getLanguage;
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("ps", "AF"),
        Locale("fa", "IR"),
        Locale("en", "US") // OR Locale('ar', 'AE') OR Other RTL locales
      ],
      locale: _language == 'English'
          ? Locale("en", "US")
          : _language == 'dari'
              ? Locale("fa", "IR")
              : Locale(
                  "ps", "AF"), // OR Locale('ar', 'AE') OR Other RTL locales,
      theme: ThemeData(
        primaryColor: Colors.deepPurple[900],
        fontFamily: 'Muna',
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: Login(),
      initialRoute: '/',
      routes: {
        '/login': (context) => Login(),
        '/register': (context) => Registration(),
        '/mainFeeds': (context) => MainScreen(),
        '/newsPostDetails': (context) => PostDetails(),
      },
    );
  }
}
