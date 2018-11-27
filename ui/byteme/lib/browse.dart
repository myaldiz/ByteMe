import 'package:flutter/material.dart';
import 'package:byteme/createCardListBrowse.dart';
import 'utils.dart';

class BrowsePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BrowsePageState();
  }
}

class BrowsePageState extends State<BrowsePage> {
  List<Widget> _cardsList = [];
  List<Tag> selectedTags = [];
  String selectedSort;

  @override
  Widget build(BuildContext context) {
    if (_cardsList.length == 0) {
      updateList();
      return Scaffold(
          appBar: AppBar(title: Text("Events")),
          body: Container(
              alignment: Alignment.center, child: CircularProgressIndicator()));
    }
    // _cardsList = filterCards(_cardsList, selectedTags);
    // _cardsList = sortCards(_cardsList, selectedSort);
    return Scaffold(
        appBar: AppBar(title: Text("Events"), actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return SortForm(onSubmit: (String newSort) {
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
        ]),
        body: Container(
            child: ListView(
          children: _cardsList,
        )));
  }

  Future<void> updateList() async {
    List<Widget> newList = await createCardListBrowse(
        'http://127.0.0.1:8000/api/v1/event/browse?type=all');
    setState(() {
      _cardsList = newList;
    });
  }
}
