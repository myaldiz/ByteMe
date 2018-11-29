import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import './token.dart';

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
  final String name;
}

typedef void TagFormCallback(List<Tag> selectedTags);

class TagForm extends StatefulWidget {
  final TagFormCallback onSubmit;
  final List<Tag> initialValue;

  TagForm({this.onSubmit, this.initialValue});

  @override
  _TagFormState createState() => new _TagFormState();
}

class _TagFormState extends State<TagForm> {
  List<Tag> selectedTags = [];
  List<Tag> allTags = [];

  @override
  void initState() {
    super.initState();
    initTags();
    if(widget.initialValue != null && widget.initialValue.length > 0){
      selectedTags = widget.initialValue;
    }
  }

  initTags() async{
    List<Tag> newTags = [];
    http.Response response = await http.get(
    Uri.encodeFull('http://127.0.0.1:8000/api/v1/event/tag/browse'), 
    headers: {"content-type": "application/json", "accept": "application/json", "Authorization": "Token " + token}
    );
    Map<String, dynamic> data = json.decode(response.body);
    for (Map<String,dynamic> tag in data["Tags"]) {
      newTags.add(Tag(tag["name"]));
    }
    setState((){
      allTags = newTags;
    });
  }

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
          textColor: Theme.of(context).primaryTextTheme.button.color,
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        RaisedButton(
          child: Text("Apply"),
          textColor: Theme.of(context).primaryTextTheme.button.color,
          color: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.of(context).pop();
            widget.onSubmit(selectedTags);
          },
        )
      ],
    );
  }
}

typedef void SortFormCallback(String selectedSort);

class SortForm extends StatefulWidget {
  final SortFormCallback onSubmit;

  SortForm({this.onSubmit});

  @override
  _SortFormState createState() => new _SortFormState();
}

class _SortFormState extends State<SortForm> {
  String selectedSort;
  List<String> allSortings = [
    "By Ranking",
    "By Name",
    "By Date",
  ];

  @override
  Widget build(BuildContext context) {
    List<Row> allRadios = [];
    for (String sorting in allSortings) {
      allRadios.add(
        Row(
          children: [
            Text(sorting),
            Radio(
              groupValue: selectedSort,
              onChanged: (dynamic sorting) {
                setState(() {
                  selectedSort = sorting;
                });
              },
              value: sorting,
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
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
        ,RaisedButton(
          textColor: Theme.of(context).primaryTextTheme.button.color,
          color: Theme.of(context).primaryColor,
          child: Text("Apply"),
          onPressed: () {
            Navigator.of(context).pop();
            widget.onSubmit(selectedSort);
          },
        )
        
      ],
    );
  }
}

class DateTimeItem extends StatelessWidget {
  DateTimeItem({Key key, this.dateTime, @required this.onChanged})
      : assert(onChanged != null),
        date = dateTime == null
            ? DateTime.now()
            : DateTime(dateTime.year, dateTime.month, dateTime.day),
        time = dateTime == null
            ? TimeOfDay.now()
            : TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
        super(key: key);

  DateTime dateTime;
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
                    dateTime ==null ? "Please select date" :
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
                  dateTime == null ? "Please select time":
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
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 1)),
        lastDate: DateTime.now().add(const Duration(days: 20000)));

    if (dateTimePicked != null) {
      onChanged(DateTime(dateTimePicked.year, dateTimePicked.month,
          dateTimePicked.day, time.hour, time.minute));
    }
  }

  Future _showTimePicker(BuildContext context) async {
    TimeOfDay timeOfDay =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (timeOfDay != null) {
      onChanged(DateTime(
          date.year, date.month, date.day, timeOfDay.hour, timeOfDay.minute));
    }
  }
}

List filterCards(List events, List selectedTags){
  var tagsSet = selectedTags.toSet();
  events = events.where((m) => !m["tags"].toSet().intersection(tagsSet).isEmpty).toList();
  return events;
}

List sortCards(List events, String criteria){
  if (criteria == "By Ranking") {
    events.sort((m1, m2) {
        var r = m1["Iscore"].compareTo(m2["Iscore"]);
        if (r != 0) return r;
      });
      events = List.from(events.reversed);
    return events;
  } else if (criteria == "By Name") {
    events.sort((m1, m2) {
      m1["title"] = m1["title"].toLowerCase();
      m2["title"] = m2["title"].toLowerCase();
        var r = m1["title"].compareTo(m2["title"]);
        if (r != 0) return r;
      });
    return events;
  } else if (criteria == "By Date"){
    events.sort((m1, m2) {
        var r = m1["time"].compareTo(m2["time"]);
        if (r != 0) return r;
      });
    return events;
  }
  return events;
}