import 'package:flutter/material.dart';
import './ModifyEventViewController.dart';
import 'package:http/http.dart' as http;
import './token.dart';

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
              child: Image.network(
                event["imgurl"],
                // "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/seminar-invite-poster-template-3b05386c8bba04259f80ef882c38b7f5_screen.jpg?ts=1515025190",
                height: 100.0,
                fit: BoxFit.cover,
              ),
              // Image.asset( //imgurl
              //   'assets/img.jpg',
              //   height: 100.0,
              //   fit: BoxFit.cover,
              // ),
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
                beautifyString(event["time"]),
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w100,
                ),
              )
            ])),
            Container(
              child: Column(children: <Widget>[
                Text(event["type"],
                style: TextStyle(color: typeColor(event["type"]))),
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
                    onPressed: ()  {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                content: Text(
                                    "Are you sure you want to delete the event?"),
                                actions: <Widget>[
                                  RaisedButton(
                                      onPressed: () {
                                        http.delete("http://127.0.0.1:8000/api/v1/event/delete/" + event["identifier"],
                                          headers: {
                                            "content-type": "application/json",
                                            "accept": "application/json",
                                            "Authorization": "Token " + token
                                          });
                                        Navigator.of(context).pop();
                                      },
                                      textColor: Theme.of(context).primaryTextTheme.button.color,
                                      child: Text(
                                        'Yes',
                                      )),
                                  RaisedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      textColor: Theme.of(context).primaryTextTheme.button.color,
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

String beautifyString(String date) {
  var monthsAbbreviations = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  var dt = DateTime.parse(date);
  var hour = dt.hour.toString().length == 1 ? "0"+dt.hour.toString() : dt.hour.toString();
  var minute = dt.minute.toString().length == 1 ? "0"+dt.minute.toString() : dt.minute.toString();
  var str =  hour + ":" + minute + " " + dt.day.toString() + "-" + monthsAbbreviations[dt.month-1] + "-" + dt.year.toString();
  return str;
}

Color typeColor(String type){
  if(type=="Accepted"){
    return Colors.green;
  }else if(type=="Processing"){
      return Colors.deepOrangeAccent;
  }else{
    return Colors.red;
  }
}