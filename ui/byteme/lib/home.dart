import 'package:flutter/material.dart';

import 'browse.dart';
import 'manage.dart';
import 'attending.dart';

class Tag{
  Tag(this.name);
  final name;
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  List<Tag> allTags;
  List<Tag> selectedTags;

  List<Widget> _bodies = [
    ManagePage(),
    BrowsePage(),
    AttendingPage(),
  ];


  int _currentIndex = 1;
  // Widget customBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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