import 'package:flutter/material.dart';

import 'utils.dart';

class AttendingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AttendingPageState();
  }
}

class AttendingPageState extends State<AttendingPage> {
  List<Widget> cardsList = [];

  @override
  Widget build(BuildContext context) {
    if (cardsList.length == 0) {
      updateList();
      return Container();
    }
    return Container(
        child: ListView(
          children: cardsList,
        ));
  }

  Future<void> updateList() async {
    List<Widget> newList = await createCardList(
        'JsonInterface/Server_Response/List_events.json');
    setState(() {
      cardsList = newList;
    });
  }
}