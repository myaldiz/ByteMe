import 'package:flutter/material.dart';

import 'modifyProfile.dart';
import 'utils.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {
  List<Tag> selectedTags = [];
  Tag selectedSort;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => ModifyProfile()),
                );
              },
            )
          ],
        ),
        body: ListView(children: <Widget>[
          Image.asset(
              'assets/img.jpg',
              height: 250.0,
              fit: BoxFit.cover,
            ),
          Text(
            "Department",
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Computer Science",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 20.0),),
          Text(
            "Tags",
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Sports",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            "Food",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            "Science",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],));
  }
}
