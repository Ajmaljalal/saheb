import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store/store.dart';
import '../languages/index.dart';
import './market/index.dart';
import './news/index.dart';
import './settings/index.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentScreenIndex = 0;

  final List<Widget> screens = [
    News(),
    Market(),
    Settings(),
  ];

  void _setCurrentScreen(int index) {
    setState(() {
      _currentScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = Provider.of<Store>(context).getLanguage;
    final appLanguage = getLanguages(context);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('your feeds'),
      ),
      body: screens[_currentScreenIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _setCurrentScreen,
        currentIndex: _currentScreenIndex,
        backgroundColor: Colors.deepPurple[900],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        unselectedFontSize: 16,
        selectedFontSize: 18,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(
              language == 'English' ? 'Home' : appLanguage['home'],
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            title: Text(
              language == 'English' ? 'Market' : appLanguage['market'],
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text(
              language == 'English' ? 'Settings' : appLanguage['settings'],
            ),
          ),
        ],
      ),
    );
  }
}
