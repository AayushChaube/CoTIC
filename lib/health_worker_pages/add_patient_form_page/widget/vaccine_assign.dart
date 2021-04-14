import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VaccineAssignDropDown extends StatefulWidget {
  final List<String> vaccineList;

  const VaccineAssignDropDown({Key key, this.vaccineList}) : super(key: key);

  @override
  _VaccineAssignDropDownState createState() => _VaccineAssignDropDownState();
}

class _VaccineAssignDropDownState extends State<VaccineAssignDropDown> {
  // Future<List<String>> getVaccine() async {
  //   final List<String> queryList = ["NA"];
  //   final QuerySnapshot query =
  //       await FirebaseFirestore.instance.collection("Vaccines").get();
  //   final List<QueryDocumentSnapshot> querylist = query.docs;
  //   querylist.forEach(
  //     (element) {
  //       queryList.add(element.data()["vaccine_name"]);
  //     },
  //   );
  //   return queryList;
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<VaccineAssignProvider>(builder: (context, notifer, _) {
      return Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Assigned Vaccine",
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
              items: widget.vaccineList
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

class VaccineAssignProvider extends ChangeNotifier {
  String value = "NA";

  String get getValue => value;

  void changeValue(String value1) {
    value = value1;
    notifyListeners();
  }
}
