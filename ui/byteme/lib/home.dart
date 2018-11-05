import 'package:flutter/material.dart';

import 'browse.dart';
import 'manage.dart';
import 'attending.dart';
import './AddEventViewController.dart';


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
    List<List<Widget>> _actions = [
      [
        IconButton(
          icon: Icon(Icons.sort),
          onPressed: null,
        ),
        IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: null,
        ),
        IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddEventViewController()),
              );
            })
      ],
      [
        IconButton(
          icon: Icon(Icons.sort),
          onPressed: null,
        ),
        IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: null,
        ),
      ],
      [
        IconButton(
          icon: Icon(Icons.sort),
          onPressed: null,
        ),
        IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: null,
        ),
      ],
    ];
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(title: _titles[_currentIndex],
            actions: _actions[_currentIndex]),
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
