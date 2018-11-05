import 'package:flutter/material.dart';

import 'utils.dart';

class ManagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ManagePageState();
  }
}

class ManagePageState extends State<ManagePage> {
  List<Widget> _cardsList = [];
  static List<Widget> actions = [];

  @override
  Widget build(BuildContext context) {
    if (_cardsList.length == 0) {
      updateList();
      return Container();
    }
    return Container(
        child: ListView(
      children: _cardsList,
    ));
  }

  Future<void> updateList() async {
    List<Widget> newList =
        await createCardList('JsonInterface/Server_Response/modify_event.json');
    setState(() {
      _cardsList = newList;
    });
  }
}

