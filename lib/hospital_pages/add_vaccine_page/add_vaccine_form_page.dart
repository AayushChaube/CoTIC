import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidtracer/themes/custom_colors.dart';
import 'package:covidtracer/widgets/custom_button.dart';
import 'package:covidtracer/widgets/showAlertDialog.dart';
import 'package:covidtracer/widgets/showLoading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class AddVaccineFormPage extends StatefulWidget {
  @override
  _AddVaccineFormPageState createState() => _AddVaccineFormPageState();
}

class _AddVaccineFormPageState extends State<AddVaccineFormPage> {
  final TextEditingController _vaccineNameController = TextEditingController();

  final TextEditingController _vaccineDueAgeController =
      TextEditingController();

  final TextEditingController _vaccineMaxAgeController =
      TextEditingController();

  final TextEditingController _vaccineRouteController = TextEditingController();

  final TextEditingController _vaccineSiteController = TextEditingController();

  final TextEditingController _doseController = TextEditingController();

  void submit() async {
    try {
      showLoading(context);
      final uid = Uuid().v4();
      final String hospitalId = FirebaseAuth.instance.currentUser.uid;
      final String historyUID = Uuid().v4();
      await FirebaseFirestore.instance.collection("Vaccines").doc(uid).set({
        "vaccine_Id": uid,
        "vaccine_name": _vaccineNameController.text,
        "due_Age": _vaccineDueAgeController.text,
        "max_Age": _vaccineMaxAgeController.text,
        "route": _vaccineRouteController.text,
        "site": _vaccineSiteController.text,
        "assigned": "",
        "hospital_id": hospitalId,
        "created": DateTime.now(),
        "remaining_vaccine": int.parse(_doseController.text),
        "latest_stock_UID": historyUID,
      });
      await FirebaseFirestore.instance
          .collection("Vaccines")
          .doc(uid)
          .collection("History")
          .doc(historyUID)
          .set({
        "uid": historyUID,
        "stock_number": int.parse(_doseController.text),
        "process": "add",
        "timestamp": DateTime.now(),
      });
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } on FirebaseException catch (e) {
      showAlertDialog(context, title: "Error", content: e.message);
    }
  }

  @override
  void dispose() {
    _vaccineNameController.dispose();
    _vaccineDueAgeController.dispose();
    _vaccineMaxAgeController.dispose();
    _vaccineRouteController.dispose();
    _vaccineSiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.primaryBlue,
        centerTitle: true,
        title: Text("Add Vaccine"),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(10.0),
        children: [
          VaccineNameInput(),
          SizedBox(height: 10.0),
          VaccineDueAgeInput(),
          SizedBox(height: 10.0),
          VaccineMaxAgeField(),
          SizedBox(height: 10.0),
          VaccineRouteInput(),
          SizedBox(height: 10.0),
          VaccineSiteField(),
          SizedBox(height: 10.0),
          VaccineStockField(),
          SizedBox(height: 10.0),
          CustomButton(
            desktopMaxWidth: MediaQuery.of(context).size.width / 1.0,
            buttonHeight: 60.0,
            buttonTitle: "Add Vaccine",
            buttonColor: CustomColors.primaryBlue,
            textColor: Colors.white,
            buttonRadius: 3.0,
            onPressed: submit,
          ),
        ],
      ),
    );
  }

  Widget VaccineNameInput() {
    return TextField(
      controller: _vaccineNameController,
      decoration: InputDecoration(
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
        hintText: "Vaccine Name",
        hintStyle: TextStyle(color: Colors.black54),
      ),
      style: Theme.of(context).textTheme.headline6,
    );
  }

  Widget VaccineDueAgeInput() {
    return TextField(
      controller: _vaccineDueAgeController,
      decoration: InputDecoration(
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
        hintText: "Vaccine Due Age",
        hintStyle: TextStyle(color: Colors.black54),
      ),
      style: Theme.of(context).textTheme.headline6,
    );
  }

  Widget VaccineMaxAgeField() {
    return TextField(
      controller: _vaccineMaxAgeController,
      decoration: InputDecoration(
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
        hintText: "Vaccine Max Age",
        hintStyle: TextStyle(color: Colors.black54),
      ),
      style: Theme.of(context).textTheme.headline6,
    );
  }

  Widget VaccineRouteInput() {
    return TextField(
      controller: _vaccineRouteController,
      decoration: InputDecoration(
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
        hintText: "Vaccine Route",
        hintStyle: TextStyle(color: Colors.black54),
      ),
      style: Theme.of(context).textTheme.headline6,
    );
  }

  Widget VaccineSiteField() {
    return TextField(
      controller: _vaccineSiteController,
      decoration: InputDecoration(
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
        hintText: "Vaccine Site",
        hintStyle: TextStyle(color: Colors.black54),
      ),
      style: Theme.of(context).textTheme.headline6,
    );
  }

  Widget VaccineStockField() {
    return TextField(
      controller: _doseController,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
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
        hintText: "Vaccine Stock(units)",
        hintStyle: TextStyle(color: Colors.black54),
      ),
      style: Theme.of(context).textTheme.headline6,
    );
  }
}
