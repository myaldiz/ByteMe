import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Log in"),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: main_widgets)));
  }

  final main_widgets = <Widget>[
    FlutterLogo(size: 50.0),
    SizedBox(height: 50.0),
    TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    ),
    SizedBox(height: 20.0),
    TextFormField(
      obscureText: true,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    ),
    SizedBox(height: 35.0),
    MaterialButton(
      color: Colors.blue, //tmp
      child: Text("Log in"),
      onPressed: null,
    ),
  ];
}
