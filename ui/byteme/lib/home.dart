import 'package:flutter/material.dart';

import 'browse.dart';
import 'manage.dart';
import 'attending.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {

  List<Widget> _bodies = [
    BrowsePage(),
    ManagePage(),
    AttendingPage(),
  ];
  List<Text> _titles = [
    Text("Browse"),
    Text("Manage"),
    Text("Attending")
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
            title: _titles[_currentIndex],
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
        body: _bodies[_currentIndex]
    );
  }
}