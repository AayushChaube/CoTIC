import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../health_worker_pages/patients_page/patient_detail_page.dart';
import '../../health_worker_pages/patients_page/thirdTab.dart';
import '../../themes/custom_colors.dart';
import 'HWPatientLatestCOVIDData.dart';

class PatientDataTab extends StatelessWidget {
  final String id;

  const PatientDataTab({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance.collection("Patients").doc(id).snapshots(),
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
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(
                    // health worker name
                    snapshot.data.data()["patient_first_name"] +
                        " " +
                        snapshot.data.data()["patient_last_name"],
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  centerTitle: true,
                  bottom: TabBar(
                    physics: BouncingScrollPhysics(),
                    indicatorWeight: 3.0,
                    indicatorColor: CustomColors.primaryBlue,
                    tabs: [
                      Tab(
                        child: Text(
                          "Personal Details",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      Tab(
                        child: Text(
                          "COVID Data",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                                fontSize: 17.0,
                              ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Vaccination Report",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    PatientDetailPage(
                      patientId: id,
                    ),
                    HWPatienLatestCOVIDData(
                      id: snapshot.data.id,
                      latest_covid: snapshot.data.data()["latest_COVID"],
                    ),
                    ThirdTab(
                      id: snapshot.data.id,
                    ),
                  ],
                ),
              ),
            );
          default:
            return Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}
