import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import './providers/languageProvider.dart';
import './providers/postsProvider.dart';
import './providers/adverts.dart';
import './providers/authProvider.dart';
import 'screens/startups/login_screen.dart';
import 'screens/startups/index.dart';
import 'screens/startups/registration_screen.dart';
import './screens/main__screen.dart';
import './screens/posts/postDetails.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
        ChangeNotifierProvider.value(
          value: LanguageProvider(),
        ),
        ChangeNotifierProvider.value(
          value: PostsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: Adverts(),
        ),
      ],
      child: Application(),
    );
  }
}

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String _language = Provider.of<LanguageProvider>(context).getLanguage;
    bool _isAuth = Provider.of<AuthProvider>(context).isAuth;
    print('auth is: $_isAuth');
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
        primaryColor: Colors.cyan[800],
        accentColor: Colors.cyanAccent[700],
        fontFamily: _language == 'English' ? 'Roboto' : 'ZarReg',
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: _isAuth == true ? MainScreen() : StartUps(),
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
