import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'token.dart';

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
  List<Tag> allTags;

  @override
  void initState() {
    super.initState();
    initTags();
    
  }

  initTags() async{
    List<Tag> newTags = [];
    http.Response response = await http.get(
    Uri.encodeFull('http://127.0.0.1:8000/api/v1/event/tag/browse'), 
    headers: {"content-type": "application/json", "accept": "application/json", "Authorization": "Token  " + token}
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
    print(selectedTags);
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
    "By popularity",
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
        initialDate: DateTime.now(),
        firstDate: date.subtract(const Duration(days: 1)),
        lastDate: date.add(const Duration(days: 20000)));

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

List<Widget> filterCards(List<Widget> cards, List<Tag> selectedTags){
  
}

List<Widget> sortCards(List<Widget> cards, String sorting){

}