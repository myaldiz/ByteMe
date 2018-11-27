import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'token.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginPage> {
  static final _email = TextEditingController();
  static final _password = TextEditingController();
  String email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Log In"),
        ),
        body: ListView(children: mainWidgets(context)));
  }

  Future<bool> authenticate() async {
    setState(() {
      email = _email.text;
      password = _password.text;
    });
    Map<String, dynamic> data = {};
    data["username"] = email;
    data["password"] = password;
    var tool = JsonEncoder();
    var json = tool.convert(data);
    // var json = JSON.encode(data);
    bool acceptance = await makeRequest(json);
    // Map<String, dynamic> response =
    //     await getJson('JsonInterface/Server_Response/login.json');
    // String result = response["Example_responses"][1]["result"];
    // if (result == "accepted") {
    //   return true;
    // } else {
    //   return false;
    // }
    return acceptance;
  }

  Future<bool> makeRequest(String postJson) async {
    var response = await http.post(
        Uri.encodeFull('http://127.0.0.1:8000/api/v1/account/api-token-auth/'),
        body: postJson,
        headers: {
          "content-type": "application/json",
          "accept": "application/json"
        });
    if (response.statusCode == 200) {
      token = json.decode(response.body)["token"];
      print(token);
    } else {
      print("UUUU");
    }
    return response.statusCode == 200;
  }

  mainWidgets(BuildContext context) {
    return <Widget>[
      SizedBox(height: 100.0),
      FlutterLogo(size: 70.0),
      Padding(
          padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 10.0),
          child: TextFormField(
            controller: _email,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: InputDecoration(
              hintText: 'Username',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            ),
            onFieldSubmitted: (value){onSubmit();}
          )),
      Padding(
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 40.0),
          child: TextFormField(
            controller: _password,
            obscureText: true,
            autofocus: false,
            decoration: InputDecoration(
              hintText: 'Password',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            ),
            onFieldSubmitted: (value){onSubmit();},
          )),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 150.0),
          child: RaisedButton(
            color: Theme.of(context).primaryColor,
            child: Text(
              'Log In',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: onSubmit,
          )),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 150.0),
          child: RaisedButton(
            color: Theme.of(context).primaryColor,
            child: Text(
              'Sign Up',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              Navigator.of(context).pushNamed('/signup');
            },
          )),
    ];
  }

  void onSubmit() async{
      //   List events = [
      // {"identifier": "c2cd246a-071e-4bbe-aff2-4404f7cf1f0f",  
      // "time": "2018-11-07 08:15:00+00:00", 
      // "title": "zsfds", 
      // "Iscore": "0.8"}, 
      // {"identifier": "302e8329-d191-487a-9da4-caa82325d8df",
      // "time": "2018-11-07 08:12:00+00:00", 
      // "title": "sadfeg", 
      // "Iscore": "0.5"}
      // ];

      // events.sort((m1, m2) {
      //   var r = m1["time"].compareTo(m2["time"]);
      //   if (r != 0) return r;
      // });

      // print(events);


    if (await authenticate()) {
      Navigator.of(context).popAndPushNamed('/');
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Text("Login Failed!"),
                actions: <Widget>[
                  RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Try Again',
                        style: TextStyle(color: Colors.white),
                      ))
                ]);
          });
    }
  }
}
