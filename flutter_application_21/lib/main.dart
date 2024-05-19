import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'menu_screen.dart';
import 'levels_screen.dart';

void main() {
  runApp(TappingGameApp());
}

class TappingGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tapping Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: _checkLogin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data == true) {
              return MenuScreen();
            } else {
              return LoginScreen();
            }
          }
        },
      ),
      routes: {
        '/menu': (context) => MenuScreen(),
        '/login': (context) => LoginScreen(),
        '/levels': (context) => LevelsScreen(),
      },
    );
  }

  Future<bool> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') != null &&
        prefs.getString('password') != null;
  }
}
