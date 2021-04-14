import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HWPatienLatestCOVIDData extends StatelessWidget {
  final String id;
  final String latest_covid;

  const HWPatienLatestCOVIDData({Key key, this.id, this.latest_covid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Patients/$id/History")
            .doc(latest_covid)
            .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              return ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(10.0),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  SizedBox(height: 10.0),
                  ListTile(
                    title: Text(
                      "Temperature (°F) : ",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      snapshot.data.data()["temperature"],
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ListTile(
                    title: Text(
                      "SpO2 (%): ",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      snapshot.data.data()["spo"],
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ListTile(
                    title: Text(
                      "ILI Symptoms: ",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      snapshot.data.data()["symptom"],
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ListTile(
                    title: Text(
                      "COVID Conditions : ",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      snapshot.data.data()["covid"],
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ListTile(
                    title: Text(
                      "Co-Morbid Conditions : ",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      snapshot.data.data()["coMorbid"],
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ListTile(
                    title: Text(
                      "Vaccine given : ",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      snapshot.data.data()["vaccine"],
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ],
              );
            default:
              return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
