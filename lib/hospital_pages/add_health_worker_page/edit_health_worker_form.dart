import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidtracer/health_worker_pages/add_patient_form_page/widget/gender_dropdown.dart';
import 'package:covidtracer/themes/custom_colors.dart';
import 'package:covidtracer/widgets/custom_button.dart';
import 'package:covidtracer/widgets/showAlertDialog.dart';
import 'package:covidtracer/widgets/showLoading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class EditHealthWorkerFormPage extends StatefulWidget {
  final String id;

  EditHealthWorkerFormPage({@required this.id});

  @override
  _EditHealthWorkerFormPageState createState() =>
      _EditHealthWorkerFormPageState();
}

class _EditHealthWorkerFormPageState extends State<EditHealthWorkerFormPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _healthWorkerEmail = TextEditingController();
  final TextEditingController _healthWorkerPassword = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  final FocusNode _firstNameNode = FocusNode();
  final FocusNode _lastNameNode = FocusNode();
  final FocusNode _mobileFocusNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode focusNode = FocusNode();
  File _image;
  final picker = ImagePicker();
  String _imageUrl;
  DocumentSnapshot document;

  bool visibility = true;

  Future<void> submit() async {
    try {
      showLoading(context);
      final String uid = Uuid().v4();
      //    final String downloadUrl = await uploadFile(uid);
      //  print(downloadUrl);
      String hospitalId = FirebaseAuth.instance.currentUser.uid;
      String uploadUrl;
      if (_image != null) {
        uploadUrl = await _uploadDataToStorage();
      } else {
        uploadUrl = _imageUrl;
      }
      final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("Hospitals")
          .doc(hospitalId)
          .get();

      await FirebaseFirestore.instance
          .collection("Health Workers")
          .doc(widget.id)
          .update({
        "first_name": _firstNameController.text,
        "last_name": _lastNameController.text,
        //  "profile_image": downloadUrl,
        "email": _healthWorkerEmail.text,
        "password": _healthWorkerPassword.text,
        "gender": Provider.of<GenderProvider>(context, listen: false).getValue,
        "created_At": DateTime.now(),
        "hospital_Id": hospitalId,
        "hospital_name": documentSnapshot.data()["hospital_name"],
        "profile_image": uploadUrl,
        "mobile": _mobileController.text,
      });
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } on FirebaseException catch (e) {
      showAlertDialog(
        context,
        title: "Error",
        content: e.message,
      );
    }
  }

  Future<String> _uploadDataToStorage() async {
    var snapshot = await FirebaseStorage.instance
        .ref()
        .child("Health Worker/${widget.id}/profile/profile.png")
        .putFile(_image);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    var data = await FirebaseFirestore.instance
        .collection("Health Workers")
        .doc(widget.id)
        .get();
    setState(() {
      document = data;
    });
    _firstNameController.text = document.data()["first_name"];
    _lastNameController.text = document.data()["last_name"];
    _healthWorkerEmail.text = document.data()["email"];
    _healthWorkerPassword.text = document.data()["password"];
    _mobileController.text = document.data()["mobile"];
    Provider.of<GenderProvider>(context, listen: false)
        .changeValue(document.data()["gender"]);
    _imageUrl = document.data()["profile_image"];
    return "complete";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: CustomColors.primaryBlue,
        title: Text(
          "Edit Health Worker",
          style: Theme.of(context).textTheme.headline6.copyWith(
                color: Colors.white,
              ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        shrinkWrap: true,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.all(10.0),
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 100.0,
                  child: _image == null
                      ? Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(_imageUrl))),
                        )
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
                  padding: const EdgeInsets.only(top: 140.0, left: 143.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      //  borderRadius: BorderRadius.circular(90),
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
          SizedBox(height: 15.0),
          FirstNameInput(),
          SizedBox(height: 15.0),
          LastNameInput(),
          SizedBox(height: 15.0),
          WorkerEmailInput(),
          SizedBox(height: 15.0),
          WorkerPasswordInput(),
          SizedBox(height: 15.0),
          WorkerMobileInput(),
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
          CustomButton(
            desktopMaxWidth: MediaQuery.of(context).size.width / 1.0,
            buttonHeight: 60.0,
            buttonTitle: "UPDATE USER",
            buttonColor: CustomColors.primaryBlue,
            textColor: Colors.white,
            buttonRadius: 3.0,
            onPressed: submit,
          ),
        ],
      ),
    );
  }

  TextField FirstNameInput() {
    return TextField(
      controller: _firstNameController,
      focusNode: _firstNameNode,
      textCapitalization: TextCapitalization.words,
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_lastNameNode),
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
    );
  }

  TextField LastNameInput() {
    return TextField(
      controller: _lastNameController,
      focusNode: _lastNameNode,
      textCapitalization: TextCapitalization.words,
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_passwordNode),
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
        hintText: "last name",
        hintStyle: TextStyle(color: Colors.black54),
      ),
      style: Theme.of(context).textTheme.headline6,
    );
  }

  TextField WorkerEmailInput() {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      controller: _healthWorkerEmail,
      autocorrect: false,
      readOnly: true,
      decoration: InputDecoration(
        filled: true,
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
        hintText: "Health-worker email",
        hintStyle: TextStyle(color: Colors.black54),
      ),
      style: Theme.of(context).textTheme.headline6,
    );
  }

  TextField WorkerPasswordInput() {
    return TextField(
      controller: _healthWorkerPassword,
      autocorrect: false,
      focusNode: _passwordNode,
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_mobileFocusNode),
      obscureText: visibility,
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
        hintText: "Password (Required)",
        hintStyle: TextStyle(color: Colors.black54),
        suffixIcon: IconButton(
          onPressed: () => setState(() => visibility = !visibility),
          icon: visibility == true
              ? Icon(
                  Icons.visibility_outlined,
                )
              : Icon(Icons.visibility_off_outlined),
        ),
      ),
      style: Theme.of(context).textTheme.headline6,
    );
  }

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

  TextField WorkerMobileInput() {
    return TextField(
      controller: _mobileController,
      autocorrect: false,
      focusNode: _mobileFocusNode,
      onEditingComplete: () => FocusScope.of(context).requestFocus(focusNode),
      keyboardType:
          TextInputType.numberWithOptions(signed: false, decimal: false),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
        hintText: "Mobile (Required)",
        hintStyle: TextStyle(color: Colors.black54),
      ),
      style: Theme.of(context).textTheme.headline6,
    );
  }
}
