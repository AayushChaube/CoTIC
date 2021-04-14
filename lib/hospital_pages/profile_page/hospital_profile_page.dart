import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidtracer/hospital_pages/profile_page/hospital_edit_profile_pagee.dart';
import 'package:covidtracer/themes/custom_colors.dart';
import 'package:covidtracer/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HospitalProfilePage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<HospitalProfilePage>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  Future<void> onRefresh() async {
    setState(() {});
    return;
  }

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser.uid;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Hospitals")
              .doc(uid)
              .snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.active:
              case ConnectionState.done:
                return new Scaffold(
                    body: new ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        new Container(
                          color: Colors.white,
                          child: new Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 20.0),
                                child: new Stack(
                                  fit: StackFit.loose,
                                  children: <Widget>[
                                    new Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        snapshot.data.data()["profile_image"] !=
                                                null
                                            ? Container(
                                                height: 190,
                                                width: 190,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      snapshot.data.data()[
                                                          "profile_image"],
                                                      scale: 1.0,
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )
                                            : CircleAvatar(
                                                radius: 90.0,
                                                child: Icon(
                                                  Icons.apartment,
                                                  size: 110.0,
                                                ),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        new Container(
                          color: Color(0xffFFFFFF),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 25.0),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 25.0),
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            new Text(
                                              "Hospital Information",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5,
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Hospital Name',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Flexible(
                                        child: new TextFormField(
                                          initialValue: snapshot.data
                                              .data()["hospital_name"],
                                          decoration: const InputDecoration(
                                            hintText: "Enter Your Name",
                                          ),
                                          readOnly: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 25.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            new Text(
                                              'Email ID',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Flexible(
                                        child: new TextFormField(
                                          initialValue: snapshot.data
                                              .data()["hospital_email"],
                                          decoration: const InputDecoration(
                                              hintText: "Enter Email ID"),
                                          enabled: !_status,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'PRN Number',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Flexible(
                                        child: new TextFormField(
                                          initialValue: snapshot.data
                                              .data()["hospital_number"],
                                          decoration: const InputDecoration(),
                                          enabled: !_status,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Phone Number',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Flexible(
                                        child: new TextFormField(
                                          initialValue: snapshot.data
                                              .data()["hospital_phone"],
                                          decoration: const InputDecoration(),
                                          enabled: !_status,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Pincode',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 2.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Flexible(
                                          child: new TextFormField(
                                            initialValue: snapshot.data
                                                .data()["hospital_code"],
                                            decoration: const InputDecoration(),
                                            enabled: !_status,
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ),
                        CustomButton(
                          desktopMaxWidth:
                              MediaQuery.of(context).size.width / 1.1,
                          buttonHeight: 55.0,
                          buttonTitle: "Edit Profile",
                          buttonColor: CustomColors.primaryBlue,
                          textColor: Colors.white,
                          buttonRadius: 3.0,
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => HospitalEditProfilePagee(
                                id: snapshot.data.id,
                                image:
                                    snapshot.data.data()["profile_image"] ?? "",
                                name: snapshot.data.data()["hospital_name"],
                                email: snapshot.data.data()["hospital_email"],
                                prn: snapshot.data.data()["hospital_number"],
                                phone: snapshot.data.data()["hospital_phone"] ??
                                    "",
                                code: snapshot.data.data()["hospital_code"],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ));
              default:
                return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }
}
