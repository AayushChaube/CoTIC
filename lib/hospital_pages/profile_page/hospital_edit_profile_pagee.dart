import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidtracer/themes/custom_colors.dart';
import 'package:covidtracer/widgets/custom_button.dart';
import 'package:covidtracer/widgets/showAlertDialog.dart';
import 'package:covidtracer/widgets/showLoading.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class HospitalEditProfilePagee extends StatefulWidget {
  final String id;
  final String image;
  final String name;
  final String prn;
  final String email;
  final String phone;
  final String code;

  HospitalEditProfilePagee({
    Key key,
    this.id,
    this.image,
    this.name,
    this.prn,
    this.email,
    this.phone,
    this.code,
  }) : super(key: key);

  @override
  _HospitalEditProfilePageeState createState() =>
      _HospitalEditProfilePageeState();
}

class _HospitalEditProfilePageeState extends State<HospitalEditProfilePagee> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  File _image;

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

  @override
  void initState() {
    _nameController.text = widget.name;
    _phoneController.text = widget.phone;
    _codeController.text = widget.code;
    super.initState();
  }

  Future<void> _submit() async {
    try {
      showLoading(context);
      String uploadUrl;
      if (_image != null) {
        uploadUrl = await _uploadDataToStorage();
      } else {
        uploadUrl = widget.image;
      }
      await FirebaseFirestore.instance
          .collection("Hospitals")
          .doc(widget.id)
          .update({
        "hospital_name": _nameController.text,
        "hospital_phone": _phoneController.text,
        "hospital_code": _codeController.text,
        "profile_image": uploadUrl ?? null,
      });
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      Navigator.of(context).pop();
      showAlertDialog(context, title: "Error", content: e.message);
    } on FirebaseException catch (e) {
      Navigator.of(context).pop();
      showAlertDialog(context, title: "Error", content: e.message);
    } catch (e) {
      Navigator.of(context).pop();
      showAlertDialog(context, title: "Error", content: e.message);
    }
  }

  Future<String> _uploadDataToStorage() async {
    var snapshot = await FirebaseStorage.instance
        .ref()
        .child("Hospital/${widget.id}/profile/profile.png")
        .putFile(_image);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text("Edit Profile"),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(10.0),
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        primary: true,
        shrinkWrap: true,
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
                              image: NetworkImage(widget.image),
                            ),
                          ),
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
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            initialValue: widget.name,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue: widget.prn,
            enabled: false,
            readOnly: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue: widget.email,
            enabled: false,
            readOnly: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          SizedBox(height: 10.0),
          TextFormField(
            controller: _phoneController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.numberWithOptions(
              signed: false,
              decimal: false,
            ),
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: "Phone Number"),
          ),
          SizedBox(height: 10.0),
          TextFormField(
            controller: _codeController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 6,
            maxLengthEnforced: true,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            keyboardType: TextInputType.numberWithOptions(
              signed: false,
              decimal: false,
            ),
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: "Pin Code"),
          ),
          SizedBox(height: 20.0),
          CustomButton(
            desktopMaxWidth: MediaQuery.of(context).size.width / 1.1,
            buttonHeight: 55.0,
            buttonTitle: "Update Profile",
            buttonColor: CustomColors.primaryBlue,
            textColor: Colors.white,
            buttonRadius: 3.0,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
