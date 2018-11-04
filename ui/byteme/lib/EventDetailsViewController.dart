import 'package:flutter/material.dart';

class EventDetailsViewController extends StatelessWidget {
  final Map<String, dynamic> event;
  EventDetailsViewController(this.event);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          "Event Information",
          // style: TextStyle(color: Colors.white),
        ),
        // iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Image.asset(
              'assets/img.jpg',
              height: 250.0,
              fit: BoxFit.cover,
            ),
          Text(
            event["title"],
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            event["time"],
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w100,
            ),
          ),
          Text(
            event["department"],
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w100,
            ),
          ),
          Text(
            event["place"],
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w100,
            ),
          ),
          Text(
            event["speaker"],
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w100,
            ),
          ),
          Text(
            event["abstract"],
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
