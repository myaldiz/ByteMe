import 'package:flutter/material.dart';

import 'login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final app_theme = ThemeData();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: app_theme,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
//        '/signup': (context) => SecondScreen(),
      },
    );
  }
}