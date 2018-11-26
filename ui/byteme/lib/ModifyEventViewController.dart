import 'package:flutter/material.dart';

import 'utils.dart';

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
  String title, place, department, speakerName, speakerUni, speakerEmail;
  String details, eventAbstract, imageURL;

  @override
  Widget build(BuildContext context) {
    final _title = TextEditingController(
      text: event["title"],
    );
    final _place = TextEditingController(
      text: event["place"],
    );
    final _department = TextEditingController(
      text: event["department"],
    );
    final _speakerName = TextEditingController(
      text: event["speaker"]["name"],
    );
    final _speakerUni = TextEditingController(
      text: event["speaker"]["univ"],
    );
    final _speakerEmail = TextEditingController(
      text: event["speaker"]["speakerEmail"],
    );
    final _details = TextEditingController(
      text: event["details"],
    );
    final _eventAbstract = TextEditingController(
      text: event["poster_image"],
    );
    final _imageURL = TextEditingController(
      text: event["abstract"],
    );
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
              TextFormField(
                controller: _department,
                decoration: InputDecoration(
                    hintText: "Department", labelText: "Department"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter information';
                  }
                },
              ),
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
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, we want to show a Snackbar
                      Navigator.pop(context);
                    }
                  },
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
}
