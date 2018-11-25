import 'package:flutter/material.dart';
import './ModifyEventViewController.dart';

class ReviewedCustomCard extends StatelessWidget {
  final Map<String, dynamic> event;

  ReviewedCustomCard(this.event);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Theme.of(context).secondaryHeaderColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              child: Image.asset(
                'assets/img.jpg',
                height: 100.0,
                fit: BoxFit.cover,
              ),
            ),
            Container(
                child: Column(children: [
              Text(
                event["title"],
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                event["abstract"],
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              Text(
                event["time"],
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w100,
                ),
              )
            ])),
            Container(
              child: Column(children: <Widget>[
                Text(event["status"]),
                Row(children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ModifyEventViewController(event)));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                content: Text(
                                    "Are you sure you want to delete the event?"),
                                actions: <Widget>[
                                  RaisedButton(
                                      onPressed: () {
                                        //TODO: Send delete request
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Yes',
                                      )),
                                  RaisedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Cancel',
                                      )),
                                ]);
                          });
                    },
                  ),
                ])
              ]),
            )
          ],
        ));
  }
}
