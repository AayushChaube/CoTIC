import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CovidConditionDropDown extends StatefulWidget {
  @override
  _CovidConditionDropDownState createState() => _CovidConditionDropDownState();
}

class _CovidConditionDropDownState extends State<CovidConditionDropDown> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CoVidConditionValueProvider>(
        builder: (context, notifer, _) {
      return Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "If Covid Positive-Current Status",
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
              value: notifer.value,
              isExpanded: true,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: Theme.of(context).textTheme.headline6,
              onChanged: notifer.changeValue,
              items: <String>[
                "NA",
                "Home Quarantine",
                "Institutional Quarantine",
                "Hospitalized",
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

class CoVidConditionValueProvider extends ChangeNotifier {
  String value = "NA";

  String get getValue => value;

  void changeValue(String value1) {
    value = value1;
    notifyListeners();
  }
}
