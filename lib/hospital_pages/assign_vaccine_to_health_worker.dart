import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidtracer/themes/custom_colors.dart';
import 'package:covidtracer/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AssignVaccineToHealth extends StatefulWidget {
  const AssignVaccineToHealth({
    Key key,
    this.healthWorkerId,
    this.vaccineId,
    this.remainingVaccine,
    this.vaccine_name,
  }) : super(key: key);

  final String healthWorkerId;
  final String vaccineId;
  final int remainingVaccine;
  final String vaccine_name;

  @override
  _AssignVaccineToHealthState createState() => _AssignVaccineToHealthState();
}

class _AssignVaccineToHealthState extends State<AssignVaccineToHealth> {
  bool _validate = true;

  final TextEditingController assignStock = TextEditingController();

  final TextEditingController zipCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.primaryBlue,
        title: Text("Assign Vaccine"),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(15.0),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        primary: true,
        children: [
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: assignStock,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.numberWithOptions(
              signed: false,
              decimal: false,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText:
                  "Enter Vaccine Stock to be Assigned (<${widget.remainingVaccine})",
              errorText: _validate
                  ? null
                  : "Assigned Stock should be less than Maximum Stock i.e. ${widget.remainingVaccine}",
            ),
          ),
          SizedBox(
            height: 15,
          ),
          TextField(
            controller: zipCode,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            maxLength: 6,
            keyboardType: TextInputType.numberWithOptions(
              signed: false,
              decimal: false,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter Pin Code",
            ),
          ),
          SizedBox(
            height: 15,
          ),
          // TextButton(
          //   onPressed: () async {
          //     bool value = validateFunction(int.tryParse(assignStock.text));
          //     print("\n " + value.toString());
          //     if (value == true) {
          //       setState(() {
          //         _validate = true;
          //       });
          //       await FirebaseFirestore.instance
          //           .collection("Health Workers")
          //           .doc(widget.healthWorkerId)
          //           .collection("Vaccines")
          //           .doc(widget.vaccineId)
          //           .set({
          //         "vaccine_Id": widget.vaccineId,
          //         "assigned_Vaccine": int.parse(assignStock.text),
          //         "remaining_vaccine":
          //             widget.remainingVaccine - int.parse(assignStock.text),
          //         "healthWorkerId": widget.healthWorkerId,
          //         "timestamp": DateTime.now(),
          //         "region": int.parse(zipCode.text),
          //         "vaccine_name": widget.vaccine_name,
          //       });
          //       await FirebaseFirestore.instance
          //           .collection("Vaccines")
          //           .doc(widget.vaccineId)
          //           .update({
          //         "remaining_vaccine":
          //             widget.remainingVaccine - int.parse(assignStock.text),
          //       });
          //       await FirebaseFirestore.instance
          //           .collection("Vaccines")
          //           .doc(widget.vaccineId)
          //           .collection("Health Workers")
          //           .doc(DateTime.now().toIso8601String())
          //           .set({
          //         "healthWorkerId": widget.healthWorkerId,
          //         "assigned_stock": int.parse(assignStock.text),
          //         "timestamp": DateTime.now(),
          //         "vaccine_name": widget.vaccine_name,
          //       });
          //       Navigator.of(context).pop();
          //     } else {
          //       setState(() {
          //         _validate = false;
          //       });
          //     }
          //   },
          //   child: Text(
          //     "Assign",
          //     style: Theme.of(context).textTheme.headline6,
          //   ),
          // ),
          CustomButton(
            desktopMaxWidth: MediaQuery.of(context).size.width / 1.0,
            buttonHeight: 60.0,
            buttonTitle: "Assign",
            buttonColor: CustomColors.primaryBlue,
            textColor: Colors.white,
            buttonRadius: 3.0,
            onPressed: () async {
              bool value = validateFunction(int.tryParse(assignStock.text));
              print("\n " + value.toString());
              if (value == true) {
                setState(() {
                  _validate = true;
                });
                final DocumentSnapshot documentSnapshot =
                    await FirebaseFirestore.instance
                        .collection("Health Workers")
                        .doc(widget.healthWorkerId)
                        .collection("Vaccines")
                        .doc(widget.vaccineId)
                        .get();
                int assigned_Vaccinee;

                if (documentSnapshot.exists == false) {
                  assigned_Vaccinee = 0;
                } else {
                  assigned_Vaccinee =
                      documentSnapshot.data()["assigned_Vaccine"];
                }
                print(assigned_Vaccinee);

                await FirebaseFirestore.instance
                    .collection("Health Workers")
                    .doc(widget.healthWorkerId)
                    .collection("Vaccines")
                    .doc(widget.vaccineId)
                    .set({
                  "vaccine_Id": widget.vaccineId,
                  "assigned_Vaccine":
                      int.parse(assignStock.text) + assigned_Vaccinee,
                  "healthWorkerId": widget.healthWorkerId,
                  "timestamp": DateTime.now(),
                  "region": int.parse(zipCode.text),
                  "vaccine_name": widget.vaccine_name,
                });
                await FirebaseFirestore.instance
                    .collection("Vaccines")
                    .doc(widget.vaccineId)
                    .update({
                  "remaining_vaccine":
                      widget.remainingVaccine - int.parse(assignStock.text),
                });
                await FirebaseFirestore.instance
                    .collection("Vaccines")
                    .doc(widget.vaccineId)
                    .collection("Health Workers")
                    .doc(DateTime.now().toIso8601String())
                    .set({
                  "healthWorkerId": widget.healthWorkerId,
                  "assigned_stock": int.parse(assignStock.text),
                  "timestamp": DateTime.now(),
                  "vaccine_name": widget.vaccine_name,
                });
                await FirebaseFirestore.instance
                    .collection("Vaccines")
                    .doc(widget.vaccineId)
                    .collection("History")
                    .doc(DateTime.now().toIso8601String())
                    .set({
                  "uid": DateTime.now(),
                  "stock_number": int.parse(assignStock.text),
                  "process": "subtract",
                  "timestamp": DateTime.now(),
                });
                Navigator.of(context).pop();
              } else {
                setState(() {
                  _validate = false;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  bool validateFunction(int value) {
    if (value < widget.remainingVaccine) {
      return true;
    } else {
      return false;
    }
  }
}
