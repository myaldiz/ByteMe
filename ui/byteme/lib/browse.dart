import 'package:flutter/material.dart';

import 'utils.dart';

class BrowsePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BrowsePageState();
  }
}

class BrowsePageState extends State<BrowsePage> {
  List<Widget> _cardsList = [];

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
    List<Widget> newList = await createCardList(
        'JsonInterface/Server_Response/List_events.json');
    setState(() {
      _cardsList = newList;
    });
  }
}

class BrowsePageAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Browse"),
      automaticallyImplyLeading: false,
      // if (_currentIndex == 0) {customBar = iconbutton}
      actions: <Widget>[

      ],
    );
  }
}