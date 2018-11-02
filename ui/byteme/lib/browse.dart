import 'package:flutter/material.dart';

class BrowsePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Browse"),
//        automaticallyImplyLeading: false, //ability to go back to login page
      ),
    );
  }
}