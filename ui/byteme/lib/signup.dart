import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './token.dart';


class SignupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignupState();
  }
}

class _SignupState extends State<SignupPage> {
  static final _email = TextEditingController();
  static final _username = TextEditingController();
  static final _password = TextEditingController();
  static final _passwordRepeat = TextEditingController();
  String username, email, password, passwordRepeat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Text("Sign Up"),
        ),
        body: Center(
            child: ListView(
                children: mainWidgets(context))));
  }

  Future<bool> authenticate() async {
    setState(() {
      email = _email.text;
      username = _username.text;
      password = _password.text;
      passwordRepeat = _passwordRepeat.text;
    });

    if (password != passwordRepeat) {
      return false;
    }
    bool result = await makeRequest(username, email, password);
    if (result) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> makeRequest(
      String username, String email, String password) async {
    Map<String, dynamic> data = {};
    Map<String, dynamic> user = {};
    data["Request"] = "Sign_up";
    user["id"] = username;
    user["email"] = email;
    user["pw_hash"] = password;
    user["type"] = "normal";
    data["User"] = user;
    var tool = JsonEncoder();
    var postJson = tool.convert(data);

    var response = await http.post(
        Uri.encodeFull(IP_ADDRESS + 'api/v1/account/register'),
        body: postJson,
        headers: {
          "content-type": "application/json",
          "accept": "application/json"
        });
    Map<String,dynamic> responseMap = json.decode(response.body);
    return responseMap["result"] == "accepted";
  }

  mainWidgets(BuildContext context) {
    return <Widget>[
      SizedBox(height: 100.0),
      FlutterLogo(size: 50.0),
      SizedBox(height: 50.0),
      TextFormField(
        controller: _username,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Username',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      ),
      SizedBox(height: 20.0),
      TextFormField(
        controller: _email,
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
        controller: _password,
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      ),
      SizedBox(height: 20.0),
      TextFormField(
        controller: _passwordRepeat,
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Repeat Password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      ),
      SizedBox(height: 7.0),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 150.0),
          child: RaisedButton(
          color: Theme.of(context).primaryColor,
          child: Text(
            'Sign Up',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            if (await authenticate()) {
              Navigator.of(context).pop();
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        content: Text("Account created. Please, Log In."),
                        actions: <Widget>[
                          RaisedButton(
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'OK',
                                style: TextStyle(color: Colors.white),
                              ))
                        ]);
                  });
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        content: Text("Sign Up Failed!"),
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
          })),
    ];
  }
}
