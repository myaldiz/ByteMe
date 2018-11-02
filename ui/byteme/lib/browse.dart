import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';

class BrowsePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BrowsePageState();
  }
}

class BrowsePageState extends State<BrowsePage> {
  List<Widget> cardsList = [];

  @override
  Widget build(BuildContext context) {
    if (cardsList.length == 0) {
      createCardList();
      return Scaffold();
    }
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
        ]),
        body: ListView(
          children: cardsList,
        ));
  }

  Future<void> createCardList() async {
    String responseString = await rootBundle
        .loadString('JsonInterface/Server_Response/List_events.json');
    Map<String, dynamic> responseContent = json.decode(responseString);
    responseContent["Events"].forEach((event) {
      event = event["Event"];
      Widget card = Card(
        child: Column(children: [Text(event["title"]),
          Text(event["place"]),
          Text(event["time"])
        ])
      );
      setState(() {
        cardsList.add(card);
      });
    });
  }
}
