import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Container(
        margin: EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration:
                    InputDecoration(hintText: "Title", labelText: "Title"),
                initialValue: event["title"],
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter information';
                  }
                },
              ),
              TextFormField(
                decoration:
                    InputDecoration(hintText: "Time", labelText: "Time"),
                initialValue: event["time"],
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter information';
                  }
                },
              ),
              TextFormField(
                decoration:
                    InputDecoration(hintText: "Place", labelText: "Place"),
                initialValue: event["place"],
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter information';
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: "Department", labelText: "Department"),
                initialValue: event["department"],
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter information';
                  }
                },
              ),
              TextFormField(
                decoration:
                    InputDecoration(hintText: "Speaker", labelText: "Speaker"),
                initialValue: event["speaker"],
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter information';
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: "Image URL", labelText: "Image URL"),
                initialValue: event["poster_image"],
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter information';
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: "Abstract", labelText: "Abstract"),
                initialValue: event["abstract"],
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
