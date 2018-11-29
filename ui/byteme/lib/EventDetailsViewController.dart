import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class EventDetailsViewController extends StatelessWidget {
  final Map<String, dynamic> event;
  EventDetailsViewController(this.event);
  @override
  Widget build(BuildContext context) {
    print(event);
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          "Event Information",
          // style: TextStyle(color: Colors.white),
        ),
        // iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Image.network(
                event["imgurl"] != null ?
                event["imgurl"]: 
                "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/seminar-invite-poster-template-3b05386c8bba04259f80ef882c38b7f5_screen.jpg?ts=1515025190",
                height: 350.0,
                fit: BoxFit.fitHeight,
              ),
          Text(
            event["title"],
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Date: " + DateFormat('EEEE, MMMM d - hh:mm').format(DateTime.parse(event["time"])),
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          // Text(
          //   event["department"],
          //   style: TextStyle(
          //     fontSize: 18.0,
          //     fontWeight: FontWeight.w100,
          //   ),
          // ),
          Text(
            "Place: " + event["place"],
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            "Speaker: " + event["speaker"]["name"],
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            event["abstract"],
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
