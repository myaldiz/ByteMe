import 'package:flutter/material.dart';
import 'createCardListModify.dart';
import 'utils.dart';
import './AddEventViewController.dart';
import './token.dart';


class ManagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ManagePageState();
  }
}

class ManagePageState extends State<ManagePage> {
  List<Widget> _cardsList = [];
  List<Tag> selectedTags = [];
  String selectedSort;

  @override
  Widget build(BuildContext context) {
    print("build");
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
            // IconButton(
            //   icon: Icon(Icons.sort),
            //   onPressed: () {
            //     showDialog(
            //         context: context,
            //         builder: (context) {
            //           return SortForm(onSubmit: (String newSort) {
            //             setState(() {
            //               selectedSort = newSort;
            //             });
            //           });
            //         });
            //   },
            // ),
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => AddEventViewController()),);
                  // ).then((value) {
                  //   updateList();
                  // });
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
        await createCardListModify(IP_ADDRESS + 'api/v1/event/browse?type=created', (){
          Navigator.of(context).popAndPushNamed('manage');
          // Navigator.of(context).pop();
        });
    setState(() {
      _cardsList = newList;
    });
  }
}
