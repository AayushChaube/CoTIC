import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CovidStatus extends StatefulWidget {
  @override
  _CovidStatusState createState() => _CovidStatusState();
}

class _CovidStatusState extends State<CovidStatus> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CovidStatusProvider>(builder: (context, notifier, _) {
      return Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Covid Condition",
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          SizedBox(height: 7.0),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 13.0,
              vertical: 10.0,
            ),
            margin: EdgeInsets.symmetric(vertical: 10.0),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: DropdownButton<String>(
              value: notifier.getValue,
              isExpanded: true,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: Theme.of(context).textTheme.headline6,
              onChanged: notifier.changeValue,
              items: <String>[
                "No Covid",
                "Covid",
                "Post Covid",
                "At-Risk",
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      );
    });
  }
}

class CovidStatusProvider extends ChangeNotifier {
  String value = "No Covid";

  String get getValue => value;

  void changeValue(String value1) {
    value = value1;
    notifyListeners();
  }
}
