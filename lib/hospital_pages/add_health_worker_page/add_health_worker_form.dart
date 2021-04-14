import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidtracer/health_worker_pages/add_patient_form_page/widget/gender_dropdown.dart';
import 'package:covidtracer/services/hospital_database_services.dart';
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
import 'package:uuid/uuid.dart';

class AddHealthWorkerFormPage extends StatefulWidget {
  @override
  _AddHealthWorkerFormPageState createState() =>
      _AddHealthWorkerFormPageState();
}

class _AddHealthWorkerFormPageState extends State<AddHealthWorkerFormPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _healthWorkerEmail = TextEditingController();
  final TextEditingController _healthWorkerPassword = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  final FocusNode _firstNameNode = FocusNode();
  final FocusNode _lastNameNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode _mobileFocusNode = FocusNode();
  final FocusNode focusNode = FocusNode();
  bool visibility = true;
  File _image;
  final picker = ImagePicker();

  Future<void> submit() async {
    final database = Provider.of<HospitalDatabaseBase>(context, listen: false);
    try {
      showLoading(context);
      final String uid = Uuid().v4();
      String uploadUrl;
      String hospitalId = FirebaseAuth.instance.currentUser.uid;
      if (_image != null) {
        uploadUrl = await database.uploadHealthWorkerImage(
          "Health Worker/$uid/profile/profile.png",
          _image,
        );
      }
      database.createHealthWorker(
        uid,
        _firstNameController.text,
        _lastNameController.text,
        _healthWorkerEmail.text,
        _healthWorkerPassword.text,
        Provider.of<GenderProvider>(context, listen: false).getValue,
        DateTime.now(),
        hospitalId,
        uploadUrl,
        _mobileController.text,
      );

      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      Navigator.of(context).pop();
      showAlertDialog(
        context,
        title: "Error",
        content: e.message,
      );
    } on FirebaseException catch (e) {
      Navigator.of(context).pop();
      showAlertDialog(
        context,
        title: "Error",
        content: e.message,
      );
    } catch (e) {
      Navigator.of(context).pop();
      showAlertDialog(
        context,
        title: "Error",
        content: e.message,
      );
    }
  }

  Future<String> _uploadDataToStorage(String path) async {
    var snapshot =
        await FirebaseStorage.instance.ref().child(path).putFile(_image);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _healthWorkerEmail.dispose();
    _healthWorkerPassword.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: CustomColors.primaryBlue,
        title: Text(
          "Add Health Worker",
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
                  padding: const EdgeInsets.only(top: 140.0, left: 143.0),
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
            "Please upload image before adding the Health Worker*",
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: Colors.red),
            textAlign: TextAlign.center,
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
            buttonTitle: "ADD USER",
            buttonColor: CustomColors.primaryBlue,
            textColor: Colors.white,
            buttonRadius: 3.0,
            onPressed: submit,
          ),
        ],
      ),
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
      onEditingComplete: () => FocusScope.of(context).requestFocus(_emailNode),
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
      focusNode: _emailNode,
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
