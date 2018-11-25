import 'package:flutter/material.dart';

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
                decoration: InputDecoration(hintText: "Title"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter information';
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Time"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter information';
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Place"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter information';
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Department"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter information';
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Speaker"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter information';
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Image URL"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter information';
                  }
                },
              ),
              TextFormField(
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
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, we want to show a Snackbar
                      Navigator.pop(context);
                    }
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
}
