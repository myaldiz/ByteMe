import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
// import './CustomCard.dart';
// import './ReviewedCustomCard.dart';

// Future<List<Widget>> createCardList(String jsonName) async {
//   List<Widget> newCardsList = [];
//   Widget card;
//   Map<String, dynamic> response = await getJson(jsonName);
//   response["Events"].forEach((event) {
//     event = event["Event"];
//     if (response["Response"] == "List_events") {
//       card = CustomCard(event);
//     } else if (response["Response"] == "Modify_event") {
//       card = ReviewedCustomCard(event);
//     } else {
//       card = Card();
//     }
//     newCardsList.add(card);
//   });
//   return newCardsList;
// }

Future<Map<String, dynamic>> getJson(String jsonName) async {
  String responseString = await rootBundle.loadString(jsonName);
  return json.decode(responseString);
}

class Tag {
  Tag(this.name);
  final name;
}

typedef void TagFormCallback(List<Tag> selectedTags);

class TagForm extends StatefulWidget {
  final TagFormCallback onSubmit;

  TagForm({this.onSubmit});

  @override
  _TagFormState createState() => new _TagFormState();
}

class _TagFormState extends State<TagForm> {
  List<Tag> selectedTags = [];
  List<Tag> allTags = [
    Tag("1"),
    Tag("2"),
    Tag("3"),
    Tag("4"),
    Tag("5"),
    Tag("6"),
    Tag("7")
  ]; //TODO: Get list of tags from server

  @override
  Widget build(BuildContext context) {
    List<CheckboxListTile> allCheckBoxes = [];
    for (Tag tag in allTags) {
      allCheckBoxes.add(
        CheckboxListTile(
          onChanged: (bool value) {
            setState(() {
              if (value) {
                selectedTags.add(tag);
              } else {
                selectedTags.remove(tag);
              }
            });
          },
          value: selectedTags.contains(tag),
          title: Text(tag.name),
        ),
      );
    }

    return AlertDialog(
      title: Text("Please select tags"),
      content: Column(
        children: allCheckBoxes,
      ),
      actions: [
        RaisedButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onSubmit(selectedTags);
            },
            child: Text("OK")),
        RaisedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
        )
      ],
    );
  }
}

typedef void SortFormCallback(Tag selectedSort);

class SortForm extends StatefulWidget {
  final SortFormCallback onSubmit;

  SortForm({this.onSubmit});

  @override
  _SortFormState createState() => new _SortFormState();
}

class _SortFormState extends State<SortForm> {
  Tag selectedSort;
  List<Tag> allTags = [
    Tag("1"),
    Tag("2"),
    Tag("3"),
    Tag("4"),
    Tag("5"),
    Tag("6"),
    Tag("7")
  ]; //TODO: Get list of tags from server

  @override
  Widget build(BuildContext context) {
    List<Row> allRadios = [];
    for (Tag tag in allTags) {
      allRadios.add(
        Row(
          children: [
            Text(tag.name),
            Radio(
              groupValue: selectedSort,
              onChanged: (dynamic tag) {
                setState(() {
                  selectedSort = tag;
                });
              },
              value: tag,
            ),
          ],
        ),
      );
    }

    return AlertDialog(
      title: Text("Please select sorting method"),
      content: Column(
        children: allRadios,
      ),
      actions: [
        RaisedButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onSubmit(selectedSort);
            },
            child: Text("OK")),
        RaisedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
        )
      ],
    );
  }
}

class DateTimeItem extends StatelessWidget {
  DateTimeItem({Key key, DateTime dateTime, @required this.onChanged})
      : assert(onChanged != null),
        date = dateTime == null
            ? new DateTime.now()
            : new DateTime(dateTime.year, dateTime.month, dateTime.day),
        time = dateTime == null
            ? new DateTime.now()
            : new TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
        super(key: key);

  final DateTime date;
  final TimeOfDay time;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new InkWell(
            onTap: (() => _showDatePicker(context)),
            child: new Padding(
                padding: new EdgeInsets.symmetric(vertical: 8.0),
                child: new Text("$date.day, $date.month $date.year"))),
          
        ),
        new InkWell(
          onTap: (() => _showTimePicker(context)),
          child: new Padding(
              padding: new EdgeInsets.symmetric(vertical: 8.0),
              child: new Text('$time')),
        ),
      ],
    );
  }

  Future _showDatePicker(BuildContext context) async {
    DateTime dateTimePicked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: date.subtract(const Duration(days: 20000)),
        lastDate: new DateTime.now());

    if (dateTimePicked != null) {
      onChanged(new DateTime(dateTimePicked.year, dateTimePicked.month,
          dateTimePicked.day, time.hour, time.minute));
    }
  }

  Future _showTimePicker(BuildContext context) async {
    TimeOfDay timeOfDay =
        await showTimePicker(context: context, initialTime: time);

    if (timeOfDay != null) {
      onChanged(new DateTime(
          date.year, date.month, date.day, timeOfDay.hour, timeOfDay.minute));
    }
  }
}