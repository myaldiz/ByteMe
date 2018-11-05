import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import './CustomCard.dart';
import './ReviewedCustomCard.dart';

Future<List<Widget>> createCardList(String jsonName) async {
  List<Widget> newCardsList = [];
  Widget card;
  Map<String, dynamic> response = await getJson(jsonName);
  response["Events"].forEach((event) {
    event = event["Event"];
    if (response["Response"] == "List_events") {
      card = CustomCard(event);
    } else if (response["Response"] == "Modify_event") {
      card = ReviewedCustomCard(event);
    } else {
      card = Card();
    }
    newCardsList.add(card);
  });
  return newCardsList;
}

Future<Map<String, dynamic>> getJson(String jsonName) async {
  String responseString = await rootBundle.loadString(jsonName);
  return json.decode(responseString);
}
