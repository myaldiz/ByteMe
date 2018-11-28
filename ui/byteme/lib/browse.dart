import 'package:flutter/material.dart';
import 'package:byteme/createCardListBrowse.dart';
import 'utils.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './token.dart';

class BrowsePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BrowsePageState();
  }
}

class BrowsePageState extends State<BrowsePage> {
  List<Widget> _cardsList = [];
  String selectedSort = "";
  Map<String, dynamic> data = {};
  List events = [];

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
        appBar: AppBar(title: Text("Events"), 
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return SortForm(onSubmit: (String newSort) {
                      setState(() {
                        selectedSort = newSort;
                        var eventsSorted = sortCards(events, selectedSort);
                        List<Widget> newList = createCardListBrowse(eventsSorted);
                        _cardsList = newList;
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
                    return TagForm(onSubmit: (List<Tag> tagsList) {
                      setState(() {
                        List<String> selectedTags = [];
                        tagsList.forEach((tagObject) {
                          selectedTags.add(tagObject.name);
                        });
                        print(events);
                        var eventsFiltered = filterCards(events, selectedTags);
                        List<Widget> newList = createCardListBrowse(eventsFiltered);
                        _cardsList = newList;
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
    http.Response response = await http.get(
        Uri.encodeFull('http://127.0.0.1:8000/api/v1/event/browse?type=all'),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": "Token " + token
        });
    setState(() {
      data = json.decode(response.body);
      events = data["Events"];
    });
    List<Widget> newList = createCardListBrowse(events);
    setState(() {
      _cardsList = newList;
    });
  }
}
