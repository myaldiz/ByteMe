import 'package:flutter/material.dart';

import 'browse.dart';
import 'manage.dart';
import 'attending.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  int index;
  HomePage(this.index);
  
  @override
  State<StatefulWidget> createState() {
    return HomePageState(index);
  }
}

class HomePageState extends State<HomePage> {
  List<Widget> _bodies = [
    ManagePage(),
    BrowsePage(),
    AttendingPage(),
    ProfilePage(),
  ];
  int index;
  HomePageState(this._currentIndex);
  int _currentIndex;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          items: [
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.event_note),
                title: Text("Manage")),
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.search),
                title: Text("Events")),
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.calendar_today),
                title: Text("Attending")),
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.person),
                title: Text("Profile")),
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
