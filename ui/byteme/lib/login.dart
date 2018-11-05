import 'package:flutter/material.dart';

import 'utils.dart';

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
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: mainWidgets(context))));
  }

  Future<bool> authenticate() async {
    setState(() {
      email = _email.text;
      password = _password.text;
    });
    Map<String, dynamic> response =
        await getJson('JsonInterface/Server_Response/login.json');
    String result = response["Example_responses"][1]["result"];
    if (result == "accepted") {
      return true;
    } else {
      return false;
    }
  }

  mainWidgets(BuildContext context) {
    return <Widget>[
      FlutterLogo(size: 50.0),
      SizedBox(height: 50.0),
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
      SizedBox(height: 35.0),
      RaisedButton(
        color: Theme.of(context).primaryColor,
        child: Text(
          'Log In',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
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
        },
      ),
      SizedBox(height: 7.0),
      RaisedButton(
        color: Theme.of(context).primaryColor,
        child: Text(
          'Sign Up',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          Navigator.of(context).pushNamed('/signup');
        },
      ),
    ];
  }
}
