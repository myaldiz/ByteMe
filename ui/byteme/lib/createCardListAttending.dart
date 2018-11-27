import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import './CustomCard.dart';
import 'package:http/http.dart' as http; 
import './token.dart';

Future<List<Widget>> createCardListAttending(String url) async {
  List<Widget> newCardsList = [];
  Widget card;
  http.Response response = await http.get(
    Uri.encodeFull(url),
    headers: {"content-type": "application/json", "accept": "application/json",  "Authorization": "Token " + token}
    );
  Map<String, dynamic> data = json.decode(response.body);
  // if data["Events"].length == 0 { draft of code for solving infinite looping in attend.dart. Add it to all "creates" for safety
  //   card = Card("No attending events")
  //   newCardsList.add(card);
  //   return newCardsList;
  // }
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
    card = CustomCard(event);
    newCardsList.add(card);
  });
  return newCardsList;
}