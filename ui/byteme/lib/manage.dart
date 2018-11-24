import 'package:flutter/material.dart';

import 'utils.dart';
import './AddEventViewController.dart';

class ManagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ManagePageState();
  }
}

class ManagePageState extends State<ManagePage> {
  List<Widget> _cardsList = [];
  List<Tag> selectedTags = [];
  Tag selectedSort;

  @override
  Widget build(BuildContext context) {
    if (_cardsList.length == 0) {
      updateList();
      return Scaffold(
        appBar: AppBar(),
        body: Container());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage"),
        actions: [
        IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return SortForm(onSubmit: (Tag newSort) {
                      setState(() {
                        selectedSort = newSort;
                      });
                    });
                  });
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return TagForm(onSubmit: (List<Tag> newList) {
                      setState(() {
                        selectedTags = newList;
                      });
                    });
                  });
            },
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
      ),
      body: Container(
        child: ListView(
      children: _cardsList,
    )));
  }

  Future<void> updateList() async {
    List<Widget> newList =
        await createCardList('JsonInterface/Server_Response/modify_event.json');
    setState(() {
      _cardsList = newList;
    });
  }
}

