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
      return Container();
    }
    return Container(
        child: ListView(
          children: cardsList,
        ));
  }

  Future<void> createCardList() async {
    List<Widget> newCardsList = [];
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
      newCardsList.add(card);
    });
    setState(() {
      cardsList = newCardsList;
    });
  }
}
