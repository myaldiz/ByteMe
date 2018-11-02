import 'package:flutter/material.dart';

import 'login.dart';
import 'signup.dart';
import 'browse.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final appTheme = ThemeData();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ByteMe',
      theme: appTheme,
      initialRoute: '/login',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => BrowsePage(),
        '/login': (BuildContext context) => LoginPage(),
        '/signup': (BuildContext context) => SignupPage(),
      },
    );
  }
}
