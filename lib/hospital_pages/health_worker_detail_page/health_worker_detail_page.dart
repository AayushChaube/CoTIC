import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidtracer/hospital_pages/health_worker_detail_page/tabs/assign_vaccine_tab.dart';
import 'package:covidtracer/hospital_pages/health_worker_detail_page/tabs/health_woker_detail_tab.dart';
import 'package:covidtracer/themes/custom_colors.dart';
import 'package:flutter/material.dart';

import 'tabs/patient_data.dart';

class HealthWorkerDetailPage extends StatelessWidget {
  final String id;

  const HealthWorkerDetailPage({Key key, @required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Health Workers")
            .doc(id)
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
              return DefaultTabController(
                length: 3,
                child: Scaffold(
                  backgroundColor: Theme.of(context).backgroundColor,
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    iconTheme: IconThemeData(
                      color: CustomColors.primaryBlue,
                    ),
                    title: Text(
                      // health worker name
                      snapshot.data.data()["first_name"] +
                          " " +
                          snapshot.data.data()["last_name"],
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    centerTitle: true,
                    bottom: TabBar(
                      physics: BouncingScrollPhysics(),
                      indicatorWeight: 3.0,
                      tabs: [
                        Tab(
                          child: Text(
                            "Details",
                            style: Theme.of(context).textTheme.subtitle2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Assign Vaccine",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Patient Data",
                            style: Theme.of(context).textTheme.subtitle2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      HealthWorkerDetailTab(id: snapshot.data.id),
                      AssignVaccineTab(healthWorkerId: snapshot.data.id),
                      PatientData(healthWorkerId: snapshot.data.id),
                    ],
                  ),
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
