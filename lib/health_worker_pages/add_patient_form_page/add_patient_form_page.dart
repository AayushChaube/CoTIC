import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidtracer/Services/sharedprefs_helper.dart';
import 'package:covidtracer/health_worker_pages/add_patient_form_page/widget/comorbid_dropdown.dart';
import 'package:covidtracer/health_worker_pages/add_patient_form_page/widget/covid_condition_dropdown.dart';
import 'package:covidtracer/health_worker_pages/add_patient_form_page/widget/covid_status_dropdown.dart';
import 'package:covidtracer/health_worker_pages/add_patient_form_page/widget/gender_dropdown.dart';
import 'package:covidtracer/health_worker_pages/add_patient_form_page/widget/symptoms_dropdown.dart';
import 'package:covidtracer/health_worker_pages/add_patient_form_page/widget/vaccine_assign.dart';
import 'package:covidtracer/themes/custom_colors.dart';
import 'package:covidtracer/widgets/custom_button.dart';
import 'package:covidtracer/widgets/showAlertDialog.dart';
import 'package:covidtracer/widgets/showLoading.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../Services/sharedprefs_helper.dart';
import 'widget/vaccine_assign.dart';

class AddPatientFormPage extends StatefulWidget {
  @override
  _AddPatientFormPageState createState() => _AddPatientFormPageState();
}

class _AddPatientFormPageState extends State<AddPatientFormPage> {
  final ScrollController _controller = ScrollController();

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();

  TextEditingController _ageController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  TextEditingController _temperatureController = TextEditingController();
  TextEditingController _spoController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  DateTime pickedDate;
  File _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    pickedDate = DateTime(1999, 10, 15);
    Duration now = DateTime.now().difference(pickedDate);
    _ageController.text = (now.inDays ~/ 365).toString();
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 70),
      lastDate: DateTime.now(),
      initialDate: pickedDate,
      selectableDayPredicate: (DateTime date) {
        if (date.isAfter(DateTime.now())) {
          return false;
        }
        return true;
      },
    );

    if (date != null)
      setState(() {
        pickedDate = date;
        Duration now = DateTime.now().difference(pickedDate);
        _ageController.text = (now.inDays ~/ 365).toString();
      });
  }

  Future<String> _uploadDataToStorage(String uid) async {
    var snapshot = await FirebaseStorage.instance
        .ref()
        .child("Patients/$uid/profile/profile.png")
        .putFile(_image);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> submit(
      List<String> add1, List<String> abc1, List<int> abcd1) async {
    try {
      List<String> add = add1;
      List<String> abc = abc1;
      List<int> abcd = abcd1;
      showLoading(context);
      final String uid = Uuid().v4();
      final String newId = Uuid().v4();
      String uploadUrl = await _uploadDataToStorage(uid);
      final String healthWorkerId = id;
      print(add);
      final int index = add.indexOf(
          Provider.of<VaccineAssignProvider>(context, listen: false).getValue);
      final String vaccineId = abc.elementAt(index);
      print(vaccineId);
      final int assinged_Stock = abcd.elementAt(add.indexOf(
          Provider.of<VaccineAssignProvider>(context, listen: false).getValue));

      await FirebaseFirestore.instance.collection("Patients").doc(uid).set(
        {
          "health_worker_Id": healthWorkerId,
          "patient_Id": uid,
          "patient_first_name": _firstNameController.text,
          "patient_last_name": _lastNameController.text,
          "dob": pickedDate,
          "age": _ageController.text,
          "gender":
              Provider.of<GenderProvider>(context, listen: false).getValue,
          "mobile": _phoneController.text,
          "email": _emailController.text,
          "address": _addressController.text,
          "created": DateTime.now(),
          "latest_time_change": DateTime.now(),
          "latest_COVID": newId,
          "profile_image": uploadUrl,
        },
      );
      await FirebaseFirestore.instance
          .collection("Patients/${uid}/History")
          .doc(newId)
          .set({
        "id": newId,
        "temperature": _temperatureController.text,
        "spo": _spoController.text,
        "symptom":
            Provider.of<SymptomProvider>(context, listen: false).getValue,
        "coMorbid":
            Provider.of<CoMorbidValueProvider>(context, listen: false).getValue,
        "covid":
            Provider.of<CoVidConditionValueProvider>(context, listen: false)
                .getValue,
        "covidStatus":
            Provider.of<CovidStatusProvider>(context, listen: false).getValue,
        "created": DateTime.now(),
        "vaccine":
            Provider.of<VaccineAssignProvider>(context, listen: false).getValue,
        "latest_time_change": DateTime.now(),
      });
      if (index > 0) {
        await FirebaseFirestore.instance
            .collection("Health Workers")
            .doc(id)
            .collection("Vaccines")
            .doc(vaccineId)
            .update({
          "assigned_Vaccine": assinged_Stock - 1,
        });
      }
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } on FirebaseException catch (e) {
      Navigator.of(context).pop();
      showAlertDialog(
        context,
        title: "Error",
        content: e.message,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print(id);
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Health Workers")
            .doc(id)
            .collection("Vaccines")
            .snapshots(),
        builder: (context, snapshot) {
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
              title: Text(
                "Add Patient",
                style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Colors.white,
                    ),
              ),
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
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 100.0,
                          child: _image == null
                              ? null
                              : Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(_image),
                                    ),
                                  ),
                                ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 140.0, left: 143.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.camera_alt),
                              onPressed: _getImage,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Please upload patient profile picture before adding the patient*",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: _firstNameController,
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
                      hintText: "First name",
                      hintStyle: TextStyle(color: Colors.black54),
                    ),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 15.0),
                  TextField(
                    controller: _lastNameController,
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
                      hintText: "Last name",
                      hintStyle: TextStyle(color: Colors.black54),
                    ),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 10.0,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Date of Birth",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Expanded(child: SizedBox.shrink()),
                        datePicker(),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.0),
                  TextField(
                    controller: _ageController,
                    readOnly: true,
                    autofocus: false,
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
                      hintText: "Age",
                      hintStyle: TextStyle(color: Colors.black54),
                    ),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 15.0),
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
                    child: GenderDropDown(focusNode),
                  ),
                  SizedBox(height: 15.0),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.numberWithOptions(
                      signed: false,
                      decimal: false,
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.call_outlined),
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
                      hintText: "Phone",
                      hintStyle: TextStyle(color: Colors.black54),
                    ),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 15.0),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
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
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.black54),
                    ),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 15.0),
                  TextField(
                    controller: _addressController,
                    textCapitalization: TextCapitalization.sentences,
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
                      hintText: "Address",
                      hintStyle: TextStyle(color: Colors.black54),
                    ),
                    style: Theme.of(context).textTheme.headline6,
                    maxLines: 3,
                    autofocus: false,
                  ),
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
                    desktopMaxWidth: MediaQuery.of(context).size.width / 1.0,
                    buttonHeight: 60.0,
                    buttonTitle: "Add Patient",
                    buttonColor: CustomColors.primaryBlue,
                    textColor: Colors.white,
                    buttonRadius: 3.0,
                    onPressed: () => submit(add, abc, abcd),
                  ),
                ],
              ),
            ),
          );
        });
  }

  // Future _getImage() async {
  //   final pickedFile = await ImagePicker.pickImage(
  //       source: ImageSource.camera, maxWidth: 480, maxHeight: 600);
  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }

  Future _getImage() async {
    return Platform.isAndroid
        ? showModalBottomSheet(
            context: context,
            builder: (context) {
              return SafeArea(
                child: Container(
                  child: new Wrap(
                    children: <Widget>[
                      new ListTile(
                          leading: new Icon(Icons.photo_library),
                          title: new Text('Photo Library'),
                          onTap: () {
                            _getImageFromGallery();
                            Navigator.of(context).pop();
                          }),
                      new ListTile(
                        leading: new Icon(Icons.photo_camera),
                        title: new Text('Camera'),
                        onTap: () {
                          _getImageFromCamer();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        : showCupertinoModalPopup(
            context: context,
            builder: (context) {
              return CupertinoActionSheet(
                actions: [
                  CupertinoActionSheetAction(
                    child: new Text('Photo Library'),
                    onPressed: () async {
                      await _getImageFromGallery();
                      Navigator.of(context).pop();
                    },
                    isDefaultAction: true,
                  ),
                  CupertinoActionSheetAction(
                    child: new Text('Camera'),
                    onPressed: () {
                      _getImageFromCamer();
                      Navigator.of(context).pop();
                    },
                    isDefaultAction: true,
                  ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  onPressed: () => Navigator.of(context).pop(),
                  isDestructiveAction: true,
                  child: Text(
                    "Cancel",
                  ),
                ),
              );
            },
          );
  }

  Future _getImageFromCamer() async {
    final pickedFile = await ImagePicker.pickImage(
        source: ImageSource.camera, maxWidth: 480, maxHeight: 600);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future _getImageFromGallery() async {
    final _pickedFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxWidth: 480, maxHeight: 600);
    setState(() {
      if (_pickedFile != null) {
        _image = new File(_pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget datePicker() {
    return InkWell(
      onTap: _pickDate,
      child: Container(
        height: 65.0,
        width: MediaQuery.of(context).size.width / 2.0,
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(5.0),
        ),
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            Text(
              " ${pickedDate.day}/ ${pickedDate.month}/${pickedDate.year}",
              style: Theme.of(context).textTheme.headline6.copyWith(
                    fontSize: 18.0,
                    fontWeight: FontWeight.normal,
                  ),
            ),
            Expanded(child: SizedBox.shrink()),
            Icon(
              Icons.arrow_drop_down,
            ),
          ],
        ),
      ),
    );
  }
}
