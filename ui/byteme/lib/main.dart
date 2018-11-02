import 'package:flutter/material.dart';

import 'login.dart';
import 'signup.dart';
import 'browse.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final app_theme = ThemeData();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: app_theme,
      initialRoute: '/login',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => BrowsePage(),
        '/login': (BuildContext context) => LoginPage(),
        '/signup': (BuildContext context) => SignupPage(),
      },
    );
  }
}
