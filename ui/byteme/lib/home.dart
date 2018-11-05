import 'package:flutter/material.dart';
import './AddEventViewController.dart';

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
    ManagePage(),
    BrowsePage(),
    AttendingPage(),
  ];
  List<Text> _titles = [Text("Manage"), Text("Events"), Text("Attending")];
  int _currentIndex = 1;
  // Widget customBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: _titles[_currentIndex],
          automaticallyImplyLeading: false,
          // if (_currentIndex == 0) {customBar = iconbutton}
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddEventViewController()),
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.assignment_turned_in), title: Text("Manage")),
            BottomNavigationBarItem(
                icon: Icon(Icons.search), title: Text("Events")),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today), title: Text("Attending"))
          ],
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        body: _bodies[_currentIndex]);
  }
}
