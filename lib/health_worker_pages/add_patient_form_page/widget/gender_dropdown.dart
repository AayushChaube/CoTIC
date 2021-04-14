import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GenderDropDown extends StatefulWidget {
  final FocusNode focusNode;
  const GenderDropDown(this.focusNode);
  @override
  _GenderDropDownState createState() => _GenderDropDownState();
}

class _GenderDropDownState extends State<GenderDropDown> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GenderProvider>(
      builder: (context, notifier, _) {
        return DropdownButton<String>(
          value: notifier.value,
          isExpanded: true,
          focusNode: widget.focusNode,
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: Theme.of(context).textTheme.headline6,
          onChanged: notifier.changeValue,
          items: <String>[
            'Female',
            'Male',
            'I prefer not to say',
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        );
      },
    );
  }
}

class GenderProvider extends ChangeNotifier {
  String value = 'Female';

  String get getValue => value;

  void changeValue(String newValue) {
    value = newValue;
    notifyListeners();
  }
}
