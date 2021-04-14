import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidtracer/Services/sharedprefs_helper.dart';
import 'package:covidtracer/hospital_pages/add_vaccine_page/vaccine_detial_page.dart';
import 'package:flutter/material.dart';

import '../../Services/sharedprefs_helper.dart';

class DailyTaskPage extends StatelessWidget {
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
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              List<QueryDocumentSnapshot> query = snapshot.data.docs;
              query.removeWhere(
                (element) =>
                    DateTime.now()
                        .difference(element.data()["timestamp"].toDate())
                        .inHours >
                    12,
              );

              if (query.length == 0) {
                return Center(
                  child: Text("No Vaccine for Today"),
                );
              }
              return Container(
                color: Theme.of(context).backgroundColor,
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(10.0),
                  itemCount: query.length,
                  itemBuilder: (context, index) => FutureBuilder<
                          DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection("Vaccines")
                          .doc(query[index].data()["vaccine_Id"])
                          .get(),
                      builder: (context, future) {
                        switch (future.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          case ConnectionState.active:
                          case ConnectionState.done:
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 7.0),
                              child: ListTile(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VaccineDetialPage(
                                              vaccine_Id: future.data.id,
                                            ))),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 5.0,
                                ),
                                title: Text(
                                  future.data.data()["vaccine_name"],
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                subtitle: Text(
                                  query[index].data()["region"].toString(),
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                trailing: Text(
                                  "Assigned: ${query[index].data()["assigned_Vaccine"]} units",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                            );
                          default:
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                        }
                      }),
                ),
              );
            default:
              return Center(
                child: CircularProgressIndicator(),
              );
          }
        });
  }
}
