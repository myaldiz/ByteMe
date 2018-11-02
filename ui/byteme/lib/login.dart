import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginPage> {
  static final emailController = TextEditingController();
  static final passwordController = TextEditingController();
  String email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Log in"),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: mainWidgets(context))));
  }

  bool authenticate(){
    setState(){
      email = emailController.text;
      password = passwordController.text;
    }
    return true;
  }

  mainWidgets(BuildContext context) {
    return <Widget>[
      FlutterLogo(size: 50.0),
      SizedBox(height: 50.0),
      TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Email',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0)),
        ),
      ),
      SizedBox(height: 20.0),
      TextFormField(
        controller: passwordController,
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0)),
        ),
      ),
      SizedBox(height: 35.0),
      RaisedButton(
        child: Text("Log in"),
        onPressed: () {
          if(authenticate()) {
            Navigator.of(context).popAndPushNamed('/');
          }
        },
      ),
      SizedBox(height: 7.0),
      RaisedButton(
        child: Text("Register"),
        onPressed: () {
          if(authenticate()) {
            Navigator.of(context).pushNamed('/signup');
          }
        },
      ),
    ];
  }
}