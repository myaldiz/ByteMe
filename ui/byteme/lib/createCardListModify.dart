import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'ReviewedCustomCard.dart';
import 'package:http/http.dart' as http; 

Future<List<Widget>> createCardListModify(String url) async {
  List<Widget> newCardsList = [];
  Widget card;
  http.Response response = await http.get(
    Uri.encodeFull(url)
    );
  Map<String, dynamic> data = json.decode(response.body);
  if (data["Events"].isEmpty) {
    card = Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [Text(
        "No events found.",
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      )]));
      newCardsList.add(card);
      return newCardsList;
  }
  data["Events"].forEach((event) {
    print(event);
    print(event["title"]);
    print(event["abstract"]);
    print(event["time"]);
    print(event["status"]);
    card = ReviewedCustomCard(event);
    newCardsList.add(card);
  });
  return newCardsList;
}
