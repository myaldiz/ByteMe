import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';

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
    Tag("Tag1"),
    Tag("Tag2"),
    Tag("Tag3"),
    Tag("Tag4"),
    Tag("Tag5"),
    Tag("Tag6"),
    Tag("Tag7")
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
          child: Text("Apply"),
          textColor: Theme.of(context).primaryTextTheme.button.color,
          onPressed: () {
            Navigator.of(context).pop();
            widget.onSubmit(selectedTags);
          },
        ),
        RaisedButton(
          textColor: Theme.of(context).primaryTextTheme.button.color,
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
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
    Tag("By popularity"),
    Tag("By Name"),
    Tag("By Date"),
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
          textColor: Theme.of(context).primaryTextTheme.button.color,
          child: Text("Apply"),
          onPressed: () {
            Navigator.of(context).pop();
            widget.onSubmit(selectedSort);
          },
        ),
        RaisedButton(
          textColor: Theme.of(context).primaryTextTheme.button.color,
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}

class DateTimeItem extends StatelessWidget {
  DateTimeItem({Key key, DateTime dateTime, @required this.onChanged})
      : assert(onChanged != null),
        date = dateTime == null
            ? DateTime.now()
            : DateTime(dateTime.year, dateTime.month, dateTime.day),
        time = dateTime == null
            ? TimeOfDay(
                hour: DateTime.now().hour, minute: DateTime.now().minute)
            : TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
        super(key: key);

  final DateTime date;
  final TimeOfDay time;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: InkWell(
            onTap: (() => _showDatePicker(context)),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 18.0),
              child: Row(
                children: [
                  Text(
                    DateFormat('EEEE, MMMM d').format(date),
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.black54),
                ],
              ),
            ),
          ),
        ),
        InkWell(
          onTap: (() => _showTimePicker(context)),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: Row(
              children: <Widget>[
                Text(
                  '${time.format(context)}',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.black54),
              ],
            ),
          ),
        )
      ],
    );
  }

  Future _showDatePicker(BuildContext context) async {
    DateTime dateTimePicked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: date.subtract(const Duration(days: 20000)),
        lastDate: DateTime.now());

    if (dateTimePicked != null) {
      onChanged(DateTime(dateTimePicked.year, dateTimePicked.month,
          dateTimePicked.day, time.hour, time.minute));
    }
  }

  Future _showTimePicker(BuildContext context) async {
    TimeOfDay timeOfDay =
        await showTimePicker(context: context, initialTime: time);

    if (timeOfDay != null) {
      onChanged(DateTime(
          date.year, date.month, date.day, timeOfDay.hour, timeOfDay.minute));
    }
  }
}
