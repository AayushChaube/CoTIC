import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidtracer/hospital_pages/health_worker_detail_page/assign_vaccine_page.dart';
import 'package:covidtracer/themes/custom_colors.dart';
import 'package:flutter/material.dart';

import '../../add_vaccine_page/vaccine_detial_page.dart';

class AssignVaccineTab extends StatefulWidget {
  final String healthWorkerId;

  const AssignVaccineTab({Key key, this.healthWorkerId}) : super(key: key);

  @override
  _AssignVaccineTabState createState() => _AssignVaccineTabState();
}

class _AssignVaccineTabState extends State<AssignVaccineTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CustomColors.primaryBlue,
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: Text(
          "Assign Vaccine",
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.white),
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AssignVaccinePagee(
              healthWorkerId: widget.healthWorkerId,
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Health Workers")
              .doc(widget.healthWorkerId)
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
                if (query.isEmpty) {
                  return Center(
                    child: Text(
                      "No Vaccines Assigned",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  );
                }
                return Container(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: query.length,
                    padding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    itemBuilder: (context, index) {
                      return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection("Vaccines")
                              .doc(query[index].data()["vaccine_Id"])
                              .get(),
                          builder: (context, future) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ListTile(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VaccineDetialPage(
                                                vaccine_Id: future.data.id,
                                              ))),
                                  title: Text(
                                    future.data.data()["vaccine_name"],
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  subtitle: Text(
                                    future.data
                                            .data()["created"]
                                            .toDate()
                                            .day
                                            .toString() +
                                        "/" +
                                        future.data
                                            .data()["created"]
                                            .toDate()
                                            .month
                                            .toString() +
                                        "/" +
                                        future.data
                                            .data()["created"]
                                            .toDate()
                                            .year
                                            .toString(),
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  trailing: Text(
                                    "Assigned: ${query[index].data()["assigned_Vaccine"]} Units",
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    physics: BouncingScrollPhysics(),
                  ),
                );
              default:
                return Center(
                  child: CircularProgressIndicator(),
                );
            }
          }),
    );
  }
}
