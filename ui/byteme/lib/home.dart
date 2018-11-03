import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';

import 'browse.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {

  List<Widget> _children = [
    BrowsePage(),
    BrowsePage(),
    BrowsePage(),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
            title: Text("Browse"),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/login');
                  })
            ]),
        bottomNavigationBar: BottomNavigationBar(items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), title: Text("Browse")),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text("Manage")),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), title: Text("View"))
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },),
        body: _children[_currentIndex]
    );
  }
}
