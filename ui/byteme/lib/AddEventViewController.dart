import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'utils.dart';
import './token.dart';

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
  List<Tag> selectedTags = [];
  String title, place, speakerName, speakerUni, speakerEmail , details, eventAbstract, imageURL;
  static final _title = TextEditingController();
  static final _place = TextEditingController();
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
                  textColor: Theme.of(context).primaryTextTheme.button.color,
                  onPressed: onSubmit,
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

  void onSubmit() async{
      if(await makeRequest()){
        Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Text(
                    "Your modifications were submitted for review. Changes will be applied after administrator's review."),
                actions: <Widget>[
                  RaisedButton(
                      textColor: Theme.of(context)
                          .primaryTextTheme
                          .button
                          .color,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'OK',
                      )),
                ]);
          });
      }else{
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Text(
                    "Request sending failed."),
                actions: <Widget>[
                  RaisedButton(
                      textColor: Theme.of(context)
                          .primaryTextTheme
                          .button
                          .color,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'OK',
                      )),
                ]);
          });
      }
  }

  Future<bool> makeRequest() async {
    if(dateTime == null){
      return false;
    }
    setState(() {
      title = _title.text;
      place = _place.text;
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
    List<Map<String,dynamic>> tagsList = [];
    for(Tag tag in selectedTags){
      tagsList.add({"name": tag.name});
    }
    event["tags"] = tagsList;
    data["Event"] = event;
    var tool = JsonEncoder();
    var postJson = tool.convert(data);
    var response = await http.post(
        Uri.encodeFull('http://127.0.0.1:8000/api/v1/event/add'),
        body: postJson,
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": "Token " + token
        });
    if(json.decode(response.body) == "Event json is not valid") return false;
    return json.decode(response.body)["status"] == "processing";
  }
}



