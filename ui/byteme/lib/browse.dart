import 'package:flutter/material.dart';

class BrowsePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text("Browse"),
        automaticallyImplyLeading: false,
        actions: <Widget>[IconButton(
            icon: Icon(Icons.exit_to_app),
          onPressed: (){Navigator.popAndPushNamed(context,'/login');})]
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Browse")),
            BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text("Manage")),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), title: Text("View"))
          ]),
    );
  }
}
