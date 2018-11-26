import 'package:flutter/material.dart';
import 'createCardListModify.dart';
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
      return Scaffold(appBar: AppBar(title: Text("Manage")), 
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator()
        ));
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
        await createCardListModify('http://mustafa:XXA83jd3kljsdf@127.0.0.1:8000/api/v1/event/browse?type=created');
    setState(() {
      _cardsList = newList;
    });
  }
}
