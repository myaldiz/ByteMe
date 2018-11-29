import 'package:flutter/material.dart';

import 'package:byteme/login.dart';
import 'package:byteme/signup.dart';
import 'package:byteme/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final appTheme = ThemeData(
    // primaryColor: Colors.blueGrey,
    // canvasColor: Colors.white,
    // secondaryHeaderColor: Colors.orangeAccent,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ByteMe',
      theme: appTheme,
      initialRoute: '/login',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => HomePage(1),
        'manage': (BuildContext context) => HomePage(0),
        '/login': (BuildContext context) => LoginPage(),
        '/signup': (BuildContext context) => SignupPage(),
      },
    );
  }
}
