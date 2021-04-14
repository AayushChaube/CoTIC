import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SymptomDropDown extends StatefulWidget {
  @override
  _SymptomDropDownState createState() => _SymptomDropDownState();
}

class _SymptomDropDownState extends State<SymptomDropDown> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SymptomProvider>(builder: (context, notifier, _) {
      return Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Family Member SARS/ILI Symptoms",
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
              items: <String>["NA", "Cough", "Cold", "Fever"]
                  .map<DropdownMenuItem<String>>((String value) {
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

class SymptomProvider extends ChangeNotifier {
  String value = "NA";

  String get getValue => value;

  void changeValue(String value1) {
    value = value1;
    notifyListeners();
  }
}
