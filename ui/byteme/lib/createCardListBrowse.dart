import 'package:flutter/material.dart';
import './CustomCard.dart';

List<Widget> createCardListBrowse(List events) {
  List<Widget> newCardsList = [];
  Widget card;
  // http.Response response = await http.get(
  //   Uri.encodeFull(url), headers: {"content-type": "application/json", "accept": "application/json", "Authorization": "Token  " + token}
  //   );
  // Map<String, dynamic> data = json.decode(response.body);
  if (events == null || events.isEmpty) {
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
