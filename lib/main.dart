import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import './providers/locationProvider.dart';
import './screens/add_posts/index.dart';
import './screens/add_posts/advert_post.dart';
import './screens/add_posts/service_post.dart';
import './screens/startups/language_screen.dart';
import './widgets/progressIndicators.dart';
import './providers/languageProvider.dart';
import './providers/postsProvider.dart';
import './providers/authProvider.dart';
import './screens/startups/login_screen.dart';
import './screens/main__screen.dart';
import './screens/posts/postDetails.dart';
import './screens/services/servicesList.dart';
import './screens/services/serviceDetails.dart';

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
          value: LocationProvider(),
        ),
        ChangeNotifierProvider.value(
          value: PostsProvider(),
        ),
      ],
      child: Application(),
    );
  }
}

class Application extends StatelessWidget {
  static var _local;
  @override
  Widget build(BuildContext context) {
    String _language = Provider.of<LanguageProvider>(context).getLanguage;

    if (_language == 'English') {
      _local = Locale("en", "US");
    }
    if (_language == 'dari') {
      _local = Locale("fa", "IR");
    }
    if (_language == 'pashto') {
      _local = Locale("ps", "AF");
    }

    return Consumer<AuthProvider>(
      builder: (context, auth, _) => MaterialApp(
        title: 'پیوست',
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          Locale("ps", "AF"),
          Locale("fa", "IR"),
          Locale("en", "US")
        ],
        locale: _local,
        theme: ThemeData(
          primaryColor: Colors.cyan[800],
          accentColor: Colors.cyanAccent[700],
          fontFamily: _language == 'English' ? 'Roboto' : 'ZarReg',
          backgroundColor: Colors.grey[100],
        ),
        home: _language == null
            ? Language()
            : auth.isAuth
                ? MainScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) => Scaffold(
                      body: authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? Center(
                              child: circularProgressIndicator(),
                            )
                          : Login(),
                    ),
                  ),
        routes: {
          '/posts': (context) => MainScreen(),
          '/postDetails': (context) => PostDetails(),
          '/addPost': (context) => AddPost(),
          '/servicesList': (context) => ServicesList(),
          '/serviceDetails': (context) => ServiceDetails(),
          '/addAdvertPost': (context) => AdvertPost(),
          '/addServicePost': (context) => ServicePost(),
        },
      ),
    );
  }
}
