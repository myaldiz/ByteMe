import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import './CustomCard.dart';
import 'package:http/http.dart' as http; 
import './token.dart';

List<Widget> createCardListBrowse(List events) {
  List<Widget> newCardsList = [];
  Widget card;
<<<<<<< HEAD
  http.Response response = await http.get(
    Uri.encodeFull(url), headers: {"content-type": "application/json", "accept": "application/json", "Authorization": "Token " + token}
    );
  Map<String, dynamic> data = json.decode(response.body);
  if (data["Events"].isEmpty) {
=======
  // http.Response response = await http.get(
  //   Uri.encodeFull(url), headers: {"content-type": "application/json", "accept": "application/json", "Authorization": "Token  " + "fc409decc5b05b43c39b8ec5b4de6a59d699afa2"}
  //   );
  // Map<String, dynamic> data = json.decode(response.body);
  if (events.isEmpty) {
>>>>>>> b603e47f8675b6435d8e4e8bde9565e0351a6f82
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
  events.forEach((event) {
    card = CustomCard(event);
    newCardsList.add(card);
  });
  return newCardsList;
}
