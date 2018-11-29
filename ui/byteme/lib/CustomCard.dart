import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './EventDetailsViewController.dart';
import 'package:intl/intl.dart';
import './token.dart';


class CustomCard extends StatelessWidget {
  final Map<String, dynamic> event;

  CustomCard(this.event);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                EventDetailsViewController(event)));
      },
      child: Card(
          color: Theme.of(context).secondaryHeaderColor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: 
                Image.network(
                event["imgurl"] != null ?
                event["imgurl"]: 
                "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/seminar-invite-poster-template-3b05386c8bba04259f80ef882c38b7f5_screen.jpg?ts=1515025190",
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
                constraints: BoxConstraints(maxWidth: 200.0),
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
                  // beautifyString(event["time"]),
                  DateFormat('EEE, d-MMM-yy, hh:mm')
                      .format(DateTime.parse(event["time"])),
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w100,
                  ),
                )
              ])),
              Container(
                  child: Column(children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.star,
                    ),
                    Text(representScore(event["Iscore"]))
                  ],
                ),
                AttendingButton(event["attendingStatus"], event["identifier"]),
              ]))
            ],
          )),
    );
  }
}

class AttendingButton extends StatefulWidget {
  final bool attendingStatus;
  final String id;
  AttendingButton(this.attendingStatus, this.id);

  @override
  State<StatefulWidget> createState() {
    return AttendingButtonState(attendingStatus, id);
  }
}

class AttendingButtonState extends State<AttendingButton> {
  bool attendingStatus;
  RaisedButton result;
  final String id;
  AttendingButtonState(this.attendingStatus, this.id);

  @override
  Widget build(BuildContext context) {
    if (attendingStatus) {
      setState(() {
        result = RaisedButton(
          child: Text("Un-Attend"),
          color: Colors.redAccent,
          onPressed: () {
            http.post("http://127.0.0.1:8000/api/v1/event/unattend/" + id,
                headers: {
                  "content-type": "application/json",
                  "accept": "application/json",
                  "Authorization": "Token " + token
                });
            setState(() {
              attendingStatus = false;
            });
          },
        );
      });
    } else {
      setState(() {
        result = RaisedButton(
          child: Text("Attend"),
          color: Colors.lightGreen,
          onPressed: () {
            http.post("http://127.0.0.1:8000/api/v1/event/attend/" + id,
                headers: {
                  "content-type": "application/json",
                  "accept": "application/json",
                  "Authorization": "Token " + token
                });
            setState(() {
              attendingStatus = true;
            });
          },
        );
      });
    }
    return result;
  }
}

String beautifyString(String date) {
  var monthsAbbreviations = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  var dt = DateTime.parse(date);
  var hour = dt.hour.toString().length == 1
      ? "0" + dt.hour.toString()
      : dt.hour.toString();
  var minute = dt.minute.toString().length == 1
      ? "0" + dt.minute.toString()
      : dt.minute.toString();
  var str = hour +
      ":" +
      minute +
      " " +
      dt.day.toString() +
      "-" +
      monthsAbbreviations[dt.month - 1] +
      "-" +
      dt.year.toString();
  return str;
}

String representScore(double score) {
  // var scoreDouble = double.parse(score);
  return (score * 10.0).toStringAsFixed(1) + " / 10";
}
