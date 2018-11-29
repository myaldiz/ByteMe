import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'utils.dart';
import './token.dart';

class ModifyEventViewController extends StatelessWidget {
  final Map<String, dynamic> event;
  ModifyEventViewController(this.event);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //        backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text("Edit Information"),
      ),
      body: MyCustomForm(event),
    );
  }
}

// Create a Form Widget
class MyCustomForm extends StatefulWidget {
  final Map<String, dynamic> event;
  MyCustomForm(this.event);
  @override
  MyCustomFormState createState() {
    return MyCustomFormState(event);
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
  final Map<String, dynamic> event;
  MyCustomFormState(this.event);

  DateTime dateTime;
  String title, place, speakerName, speakerUni, speakerEmail;
  String details, eventAbstract, imageURL;
  List<Tag> selectedTags;
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
    _title.text = event["title"];
    _place.text = event["place"];
    _speakerName.text = event["speaker"]["name"];
    _speakerUni.text = event["speaker"]["univ"];
    _speakerEmail.text = event["speaker"]["speakerEmail"];
    _details.text = event["details"];
    _eventAbstract.text = event["abstract"];
    _imageURL.text = event["imgurl"];
    List<String> initialTags = [];
    for (Map<String, dynamic> tag in event["tags"]) {
      initialTags.add(tag["name"]);
    }
    // final _title = TextEditingController(
    //   text: event["title"],
    // );
    // final _place = TextEditingController(
    //   text: event["place"],
    // );
    // final _department = TextEditingController(
    //   text: event["department"],
    // );
    // final _speakerName = TextEditingController(
    //   text: event["speaker"]["name"],
    // );
    // final _speakerUni = TextEditingController(
    //   text: event["speaker"]["univ"],
    // );
    // final _speakerEmail = TextEditingController(
    //   text: event["speaker"]["speakerEmail"],
    // );
    // final _details = TextEditingController(
    //   text: event["details"],
    // );
    // final _eventAbstract = TextEditingController(
    //   text: event["poster_image"],
    // );
    // final _imageURL = TextEditingController(
    //   text: event["abstract"],
    // );
    // Build a Form widget using the _formKey we created above
    return Container(
        margin: EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _title,
                decoration:
                    InputDecoration(hintText: "Title", labelText: "Title"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter information';
                  }
                },
              ),
              DateTimeItem(
                dateTime: DateTime.parse(event["time"]),
                onChanged: (newTime) {
                  setState(() {
                    dateTime = newTime;
                  });
                },
              ),
              TextFormField(
                controller: _place,
                decoration:
                    InputDecoration(hintText: "Place", labelText: "Place"),
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
                            return TagForm(
                              onSubmit: (List<Tag> newList) {
                                setState(() {
                                  selectedTags = newList;
                                });
                              },
                              initialValue: initialTags,
                            );
                          });
                    },
                  )),
              TextFormField(
                controller: _speakerName,
                decoration:
                    InputDecoration(hintText: "Speaker", labelText: "Speaker"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter information';
                  }
                },
              ),
              TextFormField(
                controller: _speakerUni,
                decoration: InputDecoration(
                    hintText: "Speaker University",
                    labelText: "Speaker University"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter information';
                  }
                },
              ),
              TextFormField(
                controller: _speakerEmail,
                decoration: InputDecoration(
                    hintText: "Speaker Email", labelText: "Speaker Email"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter information';
                  }
                },
              ),
              TextFormField(
                controller: _details,
                decoration:
                    InputDecoration(hintText: "Details", labelText: "Details"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter information';
                  }
                },
              ),
              TextFormField(
                controller: _imageURL,
                decoration: InputDecoration(
                    hintText: "Image URL", labelText: "Image URL"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter information';
                  }
                },
              ),
              TextFormField(
                controller: _eventAbstract,
                decoration: InputDecoration(
                    hintText: "Abstract", labelText: "Abstract"),
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
                  textColor: Theme.of(context)
                          .primaryTextTheme
                          .button
                          .color,
                  onPressed: onSubmit,
                  child: Text(
                    'Edit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  onSubmit() async{
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
      speakerUni = _speakerUni.text;
      speakerEmail = _speakerEmail.text;
      details = _details.text;
      eventAbstract = _eventAbstract.text;
      imageURL = _imageURL.text;
    });
    Map<String, dynamic> data = {};
    Map<String, dynamic> speaker = {};
    Map<String, dynamic> eventj = {};
    data["Request"] = "Modify_event";
    speaker["name"] = speakerName;
    speaker["univ"] = speakerUni;
    speaker["speakerEmail"] = speakerEmail;
    eventj["abstract"] = eventAbstract;
    eventj["place"] = place;
    eventj["time"] = dateTime.toUtc().toString();
    eventj["title"] = title;
    eventj["details"] = details;
    eventj["speaker"] = speaker;
    eventj["poster_image"] = imageURL;
    List<Map<String, dynamic>> tagsList = [];
    for (Tag tag in selectedTags) {
      tagsList.add({"name": tag.name});
    }
    eventj["tags"] = tagsList;
    data["Event"] = eventj;
    var tool = JsonEncoder();
    var postJson = tool.convert(data);
    var response = await http.post(
        Uri.encodeFull(
            'http://127.0.0.1:8000/api/v1/event/modify/' + event["identifier"]),
        body: postJson,
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": "Token " + token
        });
    return json.decode(response.body)["Response"] == "Modify_Event";
  }
}
