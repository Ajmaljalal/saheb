import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import './store/store.dart';
import './screens/login_screen.dart';
//import './screens/language_screen.dart';
import './screens/registration_screen.dart';
import './screens/main__screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Store>(
      builder: (_) => Store(),
      child: MaterialApp(
        title: 'Flutter Demo',
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          Locale("ps", "AF"), // OR Locale('ar', 'AE') OR Other RTL locales
        ],
        locale:
            Locale("ps", "AF"), // OR Locale('ar', 'AE') OR Other RTL locales,
        theme: ThemeData(
          primaryColor: Colors.deepPurple[900],
          fontFamily: 'Muna',
          scaffoldBackgroundColor: Colors.grey[200],
        ),
        home: MainScreen(),
        initialRoute: '/',
        routes: {
          '/login': (context) => Login(),
          '/register': (context) => Registration(),
          '/mainFeeds': (context) => MainScreen(),
        },
      ),
    );
  }
}
