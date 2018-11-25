import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import './CustomCard.dart';
import 'package:http/http.dart' as http; 

Future<List<Widget>> createCardListBrowse(String url) async {
  List<Widget> newCardsList = [];
  Widget card;
  http.Response response = await http.get(
    Uri.encodeFull(url)
    );
  Map<String, dynamic> data = json.decode(response.body);
  data["Events"].forEach((event) {
    card = CustomCard(event);
    newCardsList.add(card);
  });
  return newCardsList;
}
