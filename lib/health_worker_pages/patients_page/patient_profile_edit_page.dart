import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidtracer/Services/sharedprefs_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../themes/custom_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/showLoading.dart';
import '../add_patient_form_page/widget/comorbid_dropdown.dart';
import '../add_patient_form_page/widget/covid_condition_dropdown.dart';
import '../add_patient_form_page/widget/covid_status_dropdown.dart';
import '../add_patient_form_page/widget/symptoms_dropdown.dart';
import '../add_patient_form_page/widget/vaccine_assign.dart';

class PatientProfileEditPage extends StatefulWidget {
  final String patientId;

  const PatientProfileEditPage({Key key, this.patientId}) : super(key: key);

  @override
  _PatientProfileEditPageState createState() => _PatientProfileEditPageState();
}

class _PatientProfileEditPageState extends State<PatientProfileEditPage> {
  final ScrollController _controller = ScrollController();
  TextEditingController _temperatureController = TextEditingController();
  TextEditingController _spoController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  _submit(List<String> add1, List<String> abc1, List<int> abcd1) async {
    List<String> add = add1;
    List<String> abc = abc1;
    List<int> abcd = abcd1;
    showLoading(context);
    final String newId = Uuid().v4();
    print(add);
    final String vaccineId = abc.elementAt(add.indexOf(
        Provider.of<VaccineAssignProvider>(context, listen: false).getValue));
    print(vaccineId);
    final int assinged_Stock = abcd.elementAt(add.indexOf(
        Provider.of<VaccineAssignProvider>(context, listen: false).getValue));
    await FirebaseFirestore.instance
        .collection("Patients/${widget.patientId}/History")
        .doc(newId)
        .set({
      "temperature": _temperatureController.text,
      "spo": _spoController.text,
      "symptom": Provider.of<SymptomProvider>(context, listen: false).getValue,
      "coMorbid":
          Provider.of<CoMorbidValueProvider>(context, listen: false).getValue,
      "covid": Provider.of<CoVidConditionValueProvider>(context, listen: false)
          .getValue,
      "covidStatus":
          Provider.of<CovidStatusProvider>(context, listen: false).getValue,
      "created": DateTime.now(),
      "vaccine":
          Provider.of<VaccineAssignProvider>(context, listen: false).getValue,
      "latest_time_change": DateTime.now(),
    });
    await FirebaseFirestore.instance
        .collection("Patients")
        .doc(widget.patientId)
        .update({
      "latest_time_change": DateTime.now(),
      "latest_COVID": newId,
    });
    await FirebaseFirestore.instance
        .collection("Health Workers")
        .doc(id)
        .collection("Vaccines")
        .doc(vaccineId)
        .update({
      "assigned_Vaccine": assinged_Stock - 1,
    });
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Health Workers")
            .doc(id)
            .collection("Vaccines")
            .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              //getVaccineDatabase();
              List<QueryDocumentSnapshot> query = snapshot.data.docs;

              List<String> add = ['NA'];
              List<String> abc = ['NA'];
              List<int> abcd = [0];
              query.forEach((element) {
                add.add(element.data()["vaccine_name"]);
                abc.add(element.data()["vaccine_Id"]);
                abcd.add(element.data()["assigned_Vaccine"]);
              });
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: CustomColors.primaryBlue,
                  centerTitle: true,
                ),
                body: Scrollbar(
                  controller: _controller,
                  child: ListView(
                    shrinkWrap: true,
                    controller: _controller,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.all(10.0),
                    physics: BouncingScrollPhysics(),
                    children: [
                      SizedBox(height: 15.0),
                      TextField(
                        controller: _temperatureController,
                        keyboardType: TextInputType.numberWithOptions(
                          signed: false,
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                          enabledBorder: OutlineInputBorder(),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                          hintText: "Body Temperature in °F",
                          hintStyle: TextStyle(color: Colors.black54),
                          helperText:
                              "Please add Temperature level before updating",
                          helperStyle:
                              Theme.of(context).textTheme.subtitle1.copyWith(
                                    color: Colors.red,
                                  ),
                        ),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(height: 15.0),
                      TextField(
                        controller: _spoController,
                        keyboardType: TextInputType.numberWithOptions(
                          signed: false,
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                          enabledBorder: OutlineInputBorder(),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                          hintText: "SpO2 Reading in %",
                          hintStyle: TextStyle(color: Colors.black54),
                          helperText: "Please add SpO2 level before updating",
                          helperStyle:
                              Theme.of(context).textTheme.subtitle1.copyWith(
                                    color: Colors.red,
                                  ),
                        ),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(height: 15.0),
                      SymptomDropDown(),
                      SizedBox(height: 15.0),
                      CoMorbidDropdown(),
                      SizedBox(height: 15.0),
                      CovidStatus(),
                      SizedBox(height: 15.0),
                      CovidConditionDropDown(),
                      SizedBox(height: 15.0),
                      VaccineAssignDropDown(
                        vaccineList: add,
                      ),
                      SizedBox(height: 15.0),
                      CustomButton(
                        desktopMaxWidth:
                            MediaQuery.of(context).size.width / 1.0,
                        buttonHeight: 60.0,
                        buttonTitle: "Update Profile",
                        buttonColor: CustomColors.primaryBlue,
                        textColor: Colors.white,
                        buttonRadius: 3.0,
                        onPressed: () => _submit(add, abc, abcd),
                      ),
                    ],
                  ),
                ),
              );
            default:
              return Center(child: CircularProgressIndicator());
          }
        });
  }
}
