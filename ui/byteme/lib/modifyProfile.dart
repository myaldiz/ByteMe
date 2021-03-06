import 'package:flutter/material.dart';

import 'utils.dart';
import 'package:http/http.dart' as http;
import './token.dart';
import 'dart:convert';

class ModifyProfile extends StatelessWidget {
  Map<String, dynamic> initialValue;
  ModifyProfile(this.initialValue);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //        backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text("Edit Information"),
      ),
      body: MyCustomForm(initialValue),
    );
  }
}

// Create a Form Widget
class MyCustomForm extends StatefulWidget {
  Map<String, dynamic> data;
  MyCustomForm(this.data);
  @override
  MyCustomFormState createState() {
    return MyCustomFormState(data);
  }
}

// Create a corresponding State class. This class will hold the data related to
// the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> initialValue;
  MyCustomFormState(this.initialValue);

  List<Tag> selectedTags = [];
  TextEditingController _dept = TextEditingController();

@override
  void initState() {
    // TODO: implement initState
    super.initState();
     _dept.text = initialValue["dept"];
  }

  @override
  Widget build(BuildContext context) {
   
    List<String> initialTags = [];
    for(String tag in initialValue["tags"]){
      initialTags.add(tag);
    }
    // Build a Form widget using the _formKey we created above
    return Container(
        margin: EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _dept,
                decoration: InputDecoration(
                    hintText: "Department", labelText: "Department"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter information';
                  }
                },
              ),
              Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: RaisedButton(
                    child: Text("Select Tags"),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return TagForm(onSubmit: (List<Tag> newList) {
                              setState(() {
                                selectedTags = newList;
                              });
                            },
                            initialValue: initialTags,);
                          });
                    },
                  )),
              //Checkboxlist here,
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryTextTheme.button.color,
                  onPressed: () async {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, we want to show a Snackbar
                      await sendRequest();
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Edit'),
                ),
              ),
            ],
          ),
        ));
  }

  sendRequest() async{
    Map<String, dynamic> data = {};
    data["Request"] = "Modify_profile";
    data["dept"] = _dept.text;
    List<Map<String,dynamic>> tagsList = [];
    for(Tag tag in selectedTags){
      tagsList.add({"name": tag.name});
    }
    data["tags"] = tagsList;
    var tool = JsonEncoder();
    var postJson = tool.convert(data);

    await http.post(
        Uri.encodeFull(IP_ADDRESS + 'api/v1/account/modify'),
        body: postJson,
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": "Token " + token
        });
  }
}
