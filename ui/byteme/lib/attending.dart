import 'package:flutter/material.dart';
import 'utils.dart';
import 'package:byteme/createCardListAttending.dart';
import './token.dart';


class AttendingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AttendingPageState();
  }
}

class AttendingPageState extends State<AttendingPage> {
  List<Widget> _cardsList = [];
  List<Tag> selectedTags = [];
  String selectedSort;

  @override
  Widget build(BuildContext context) {
    if (_cardsList.length == 0) {
      updateList();
      return Scaffold(appBar: AppBar(title: Text("Attending")), 
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator()
        ));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Attending"),
      //   actions: [
      //   IconButton(
      //       icon: Icon(Icons.sort),
      //       onPressed: () {
      //         showDialog(
      //             context: context,
      //             builder: (context) {
      //               return SortForm(onSubmit: (String newSort) {
      //                 setState(() {
      //                   selectedSort = newSort;
      //                 });
      //               });
      //             });
      //       },
      //     ),
      //     IconButton(
      //       icon: Icon(Icons.filter_list),
      //       onPressed: () {
      //         showDialog(
      //             context: context,
      //             builder: (context) {
      //               return TagForm(onSubmit: (List<Tag> newList) {
      //                 setState(() {
      //                   selectedTags = newList;
      //                 });
      //               });
      //             });
      //       },
      //     ),
      // ],
      ),
      body: Container(
        child: ListView(
          children: _cardsList,
        )));
  }

  Future<void> updateList() async {
    List<Widget> newList = await createCardListAttending(
        IP_ADDRESS + 'api/v1/event/browse?type=attending');
    setState(() {
      _cardsList = newList;
    });
  }
}

class AttendingPageAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Attending"),
      automaticallyImplyLeading: false,
      // if (_currentIndex == 0) {customBar = iconbutton}
      actions: <Widget>[

      ],
    );
  }
}