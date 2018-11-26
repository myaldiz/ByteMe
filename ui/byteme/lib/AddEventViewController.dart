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
  final _title = TextEditingController();
  final _time = TextEditingController();
  final _place = TextEditingController();
  final _department = TextEditingController();
  final _speaker = TextEditingController();
  final _image_url = TextEditingController();
  final _abstract = TextEditingController();


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
              TextFormField(
                controller: _time,
                decoration: InputDecoration(hintText: "Time"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter information';
                  }
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
              TextFormField(
                controller: _speaker,
                decoration: InputDecoration(hintText: "Speaker"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter information';
                  }
                },
              ),
              TextFormField(
                controller: _image_url,
                decoration: InputDecoration(hintText: "Image URL"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter information';
                  }
                },
              ),
              TextFormField(
                controller: _abstract,
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
                    _sendData();
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

  void _sendData() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    print('login attempt: $username with $password');
  }
}
