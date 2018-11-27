import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'utils.dart';

class AddEventViewController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //        backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text("Add Event"),
      ),
      body: MyCustomForm(),
    );
  }
}

// Create a Form Widget
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
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

  DateTime dateTime;
  String title, place, department, speakerName, speakerUni, speakerEmail , details, eventAbstract, imageURL;
  List<Tag> selectedTags;
  static final _title = TextEditingController();
  static final _place = TextEditingController();
  static final _department = TextEditingController();
  static final _speakerName = TextEditingController();
  static final _speakerUni = TextEditingController();
  static final _speakerEmail = TextEditingController();
  static final _details = TextEditingController();
  static final _eventAbstract = TextEditingController();
  static final _imageURL = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Container(
        margin: EdgeInsets.all(15.0),
        // padding: EdgeInsets.symmetric(vertical: 50.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _title,
                decoration: InputDecoration(hintText: "Title"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter information';
                  }
                },
              ),
              DateTimeItem(
                dateTime: dateTime,
                onChanged: (newTime) {
                  setState(() {
                    dateTime = newTime;
                  });
                },
              ),
              TextFormField(
                controller: _place,
                decoration: InputDecoration(hintText: "Place"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter information';
                  }
                },
              ),
              TextFormField(
                controller: _department,
                decoration: InputDecoration(hintText: "Department"),
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
                            });
                          });
                    },
                  )),
              TextFormField(
                controller: _speakerName,
                decoration: InputDecoration(hintText: "Speaker Name"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter information';
                  }
                },
              ),
              TextFormField(
                controller: _speakerUni,
                decoration: InputDecoration(hintText: "Speaker University"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter information';
                  }
                },
              ),
              TextFormField(
                controller: _speakerEmail,
                decoration: InputDecoration(hintText: "Speaker Email"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter information';
                  }
                },
              ),
              TextFormField(
                controller: _details,
                decoration: InputDecoration(hintText: "Details"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter information';
                  }
                },
              ),
              TextFormField(
                controller: _imageURL,
                decoration: InputDecoration(hintText: "Image URL"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter information';
                  }
                },
              ),
              TextFormField(
                controller: _eventAbstract,
                decoration: InputDecoration(hintText: "Abstract"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter information';
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    makeRequest();
                    showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                content: Text(
                                    "Your event was submitted for review. It will be posted after administrator's review."),
                                actions: <Widget>[
                                  RaisedButton(
                                      onPressed: () {
                                        //TODO: Send delete request
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'OK',
                                      )),
                                ]);
                          });
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    print("===========");
                    Navigator.of(context).pop();
                    // if (_formKey.currentState.validate()) {
                    //   // If the form is valid, we want to show a Snackbar
                    //   Navigator.of(context).pop();
                    // }
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> makeRequest() async {
    setState(() {
      title = _title.text;
      place = _place.text;
      department = _department.text;
      speakerName = _speakerName.text;
      speakerUni =  _speakerUni.text;
      speakerEmail = _speakerEmail.text;
      details = _details.text;
      eventAbstract = _eventAbstract.text;
      imageURL = _imageURL.text;
    });
    Map<String, dynamic> data = {};
    Map<String, dynamic> speaker = {};
    Map<String, dynamic> event = {};
    data["Request"] = "Add_event";
    speaker["name"] = speakerName;
    speaker["univ"] = speakerUni;
    speaker["speakerEmail"] = speakerEmail;
    event["abstract"] = eventAbstract;
    event["place"] = place;
    event["time"] = dateTime.toUtc().toString();
    event["title"] = title;
    event["details"] = details;
    event["speaker"] = speaker;
    event["poster_image"] = imageURL;
    data["Event"] = event;
    var tool = JsonEncoder();
    var json = tool.convert(data);
    var response = await http.post(
        Uri.encodeFull('http://127.0.0.1:8000/api/v1/event/add'),
        body: json,
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": "Token  " + "fc409decc5b05b43c39b8ec5b4de6a59d699afa2"
        });
    return;
  }
}



