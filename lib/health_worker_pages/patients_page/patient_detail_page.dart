import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidtracer/themes/custom_colors.dart';
import 'package:flutter/material.dart';

import '../../themes/custom_colors.dart';

class PatientDetailPage extends StatelessWidget {
  final String patientId;

  const PatientDetailPage({Key key, this.patientId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Patients")
              .doc(patientId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done) {
              return ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(20.0),
                children: [
                  snapshot.data.data()["profile_image"] == null
                      ? Container(
                          height: 110,
                          width: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: CustomColors.primaryBlue,
                          ),
                        )
                      : Container(
                          height: 250,
                          width: 250,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                snapshot.data.data()["profile_image"],
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                  SizedBox(height: 20.0),
                  Text(
                    snapshot.data.data()["patient_first_name"] +
                        " " +
                        snapshot.data.data()["patient_last_name"],
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline4.copyWith(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    children: [
                      Text(
                        "Date of Birth: ",
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: SizedBox.shrink(),
                      ),
                      Text(
                        snapshot.data.data()["dob"].toDate().day.toString() +
                            "/" +
                            snapshot.data
                                .data()["dob"]
                                .toDate()
                                .month
                                .toString() +
                            "/" +
                            snapshot.data
                                .data()["dob"]
                                .toDate()
                                .year
                                .toString(),
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    children: [
                      Text(
                        "Age: ",
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: SizedBox.shrink(),
                      ),
                      Text(
                        (DateTime.now()
                                    .difference(
                                        snapshot.data.data()["dob"].toDate())
                                    .inDays ~/
                                365)
                            .toString(),
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    children: [
                      Text(
                        "Gender: ",
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: SizedBox.shrink(),
                      ),
                      Text(
                        snapshot.data.data()["gender"],
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    children: [
                      Text(
                        "Mobile: ",
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: SizedBox.shrink(),
                      ),
                      Text(
                        snapshot.data.data()["mobile"],
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    children: [
                      Text(
                        "Email: ",
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Expanded(child: SizedBox.shrink()),
                      Text(
                        snapshot.data.data()["email"],
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Address: ",
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          snapshot.data.data()["address"],
                          style: Theme.of(context).textTheme.headline5,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
