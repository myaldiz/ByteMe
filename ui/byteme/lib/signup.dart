import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignupState();
  }
}

class _SignupState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Text("Sign up"),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: mainWidgets(context))));
  }

  mainWidgets(BuildContext context) {
    return <Widget>[
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
      SizedBox(height: 20.0),
      TextFormField(
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Repeat Password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      ),
      SizedBox(height: 7.0),
      RaisedButton(
        child: Text("Register"),
        onPressed: () {
          Navigator.of(context).pop();
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    content: Text("Successful!"),
                    actions: <Widget>[
                      RaisedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("OK"))
                    ]);
              });
        },
      ),
    ];
  }
}
