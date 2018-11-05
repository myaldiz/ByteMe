import 'package:flutter/material.dart';
import './EventDetailsViewController.dart';

class CustomCard extends StatelessWidget {
  final Map<String, dynamic> event;

  CustomCard(this.event);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
              Navigator.of(context).push( MaterialPageRoute(
                    builder: (BuildContext context) => EventDetailsViewController(event)
                  ));
        },
      child: Card(
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
              child: Row(
            children: <Widget>[
              Icon(
                Icons.star,
              ),
              Text('8.7 / 10')
            ],
          ))
        ],
      )),
    );
  }
}
