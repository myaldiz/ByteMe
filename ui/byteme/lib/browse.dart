import 'package:flutter/material.dart';
import 'package:byteme/createCardListBrowse.dart';
import 'utils.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; 

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
      Uri.encodeFull('http://127.0.0.1:8000/api/v1/event/browse?type=all'), headers: {"content-type": "application/json", "accept": "application/json", "Authorization": "Token  " + "fc409decc5b05b43c39b8ec5b4de6a59d699afa2"}
    );
    setState(() {
      data = json.decode(response.body);
      events = data["Events"];
      events = [{"identifier":"c070efc7-183f-4d94-ae93-c368fee25434","creater":"mustafa, KAIST","attendant":["mustafa, KAIST","admin, KAIST"],"abstract":"BlaBla","place":"Kaist","time":"2018-11-03 03:05:00.914138+00:00","title":"Zombies","details":"Blabla","req":"non","Iscore":0.669736,"speaker":{"univ":"Ohio State University","dept":"Computer Science","tags":["Anaerobic Digestion","Microalgae","Computational Fluid Dynamics"],"name":"Stephen Park","speakerEmail":"Steve@email.com","bio":null},"tags":["Anaerobic Digestion","Microalgae","Computational Fluid Dynamics"],"attendingStatus":true,"type":"Accepted"},{"identifier":"3236eba9-93f3-41b8-888e-31219210176f","creater":"mustafa, KAIST","attendant":["admin, KAIST"],"abstract":"BlaBla","place":"Kaist","time":"2018-11-03 03:01:00.914138+00:00","title":"Zombies1","details":"Blabla","req":"non","Iscore":0.4,"speaker":{"univ":"KAIST","dept":"Computer Science","tags":[],"name":"Steve","speakerEmail":"Steveeee@email.com","bio":null},"tags":[],"attendingStatus":true,"type":"Accepted"},{"identifier":"c2cd246a-071e-4bbe-aff2-4404f7cf1f0f","creater":"admin, KAIST","attendant":[],"abstract":"sdfgh","place":"asdfg","time":"2018-11-06 08:11:00+00:00","title":"asfds","details":"asdfg","req":"del","Iscore":0.3,"speaker":{"univ":"sdgf","dept":"Computer Science","tags":[],"name":"wer","speakerEmail":"sdf@han.com","bio":null},"tags":[],"attendingStatus":false,"type":"Processing"},{"identifier":"302e8329-d191-487a-9da4-caa82325d8df","creater":"admin, KAIST","attendant":[],"abstract":"wqer","place":"dsgf","time":"2018-11-07 08:12:00+00:00","title":"sadfeg","details":"qwfe","req":"del","Iscore":0.2,"speaker":{"univ":"wer","dept":"Computer Science","tags":[],"name":"sdgf","speakerEmail":"asdf@an.com","bio":null},"tags":[],"attendingStatus":false,"type":"Processing"},{"identifier":"10d42738-6db7-412a-91d3-9b41f30c1a4e","creater":"admin, KAIST","attendant":[],"abstract":"dgf","place":"dfg","time":"2018-11-14 08:14:00+00:00","title":"sdgfe","details":"weg","req":"del","Iscore":0.1,"speaker":{"univ":"sdf","dept":"Computer Science","tags":[],"name":"sdg","speakerEmail":"sdg@kai.kai","bio":null},"tags":[],"attendingStatus":false,"type":"Processing"}];
      print("events assigned");
        });
    List<Widget> newList = createCardListBrowse(events);
    setState(() {
      _cardsList = newList;
    });
  }
}
