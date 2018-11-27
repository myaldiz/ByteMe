import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'modifyProfile.dart';
import 'utils.dart';
import 'token.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {
  List<Widget> contetList = [];

  @override
  void initState() {
    super.initState();
    initContent();
  }

  void initContent() async {
    List<Widget> newContent = [
      Image.asset(
        'assets/img1.jpg',
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
    ];
    http.Response response = await http.get(
        Uri.encodeFull('http://127.0.0.1:8000/api/v1/account/profile'),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": "Token  " + token
        });
    Map<String, dynamic> data = json.decode(response.body);
    newContent.add(
      Text(
        data["dept"],
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
    newContent.add(Padding(
      padding: EdgeInsets.only(bottom: 20.0),
    ));
    newContent.add(Text(
      "Tags",
      style: TextStyle(
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
      ),
    ));
    for (String tag in data["tags"]) {
      newContent.add(
        Text(
          tag,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.normal,
          ),
        ),
      );
    }
    newContent.add(Padding(
      padding: EdgeInsets.only(bottom: 20.0),
    ));
    newContent.add(
      Text(
        "Usernammme",
        style: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    newContent.add(
      Text(
        data["user"]["username"],
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
    setState(() {
      contetList = newContent;
    });
  }

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
                  MaterialPageRoute(builder: (context) => ModifyProfile()),
                );
              },
            )
          ],
        ),
        body: ListView(children: contetList));
  }
}
