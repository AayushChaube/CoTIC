import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidtracer/themes/custom_colors.dart';
import 'package:flutter/material.dart';

class PatientHistoryRecordData extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final String id;

  PatientHistoryRecordData(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: CustomColors.primaryBlue,
        centerTitle: true,
        title: Text(
          "Record",
          textAlign: TextAlign.center,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Patients")
            .doc(id)
            .collection("History")
            .orderBy("latest_time_change", descending: true)
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
              return Scrollbar(
                controller: _scrollController,
                child: ListView.separated(
                  controller: _scrollController,
                  shrinkWrap: true,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data.docs.length,
                  padding: EdgeInsets.all(15),
                  separatorBuilder: (context, index) => SizedBox(height: 3.0),
                  itemBuilder: (context, index) => Card(
                    elevation: 5.0,
                    child: ListTile(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PatientRecordDetials(
                            patient_Id: id,
                            historyId: snapshot.data.docs[index].id,
                          ),
                        ),
                      ),
                      title: Text(
                        snapshot.data.docs[index].data()["vaccine"],
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      subtitle: getDate(snapshot.data.docs[index], context),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ),
              );
            default:
              return Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }

  Text getDate(QueryDocumentSnapshot query, BuildContext context) {
    DateTime created = query.data()["latest_time_change"].toDate();
    DateTime now = DateTime.now();
    Duration duration = now.difference(created);
    if (duration.inDays == 0) {
      return Text(
        "Today",
        style: Theme.of(context).textTheme.subtitle1,
      );
    } else if (duration.inDays == 1) {
      return Text(
        "Yesterday",
        style: Theme.of(context).textTheme.subtitle1,
      );
    } else if (duration.inDays == 2) {
      return Text(
        "Day before yesterday",
        style: Theme.of(context).textTheme.subtitle1,
      );
    } else {
      return Text(
        query.data()["latest_time_change"].toDate().day.toString() +
            "/" +
            query.data()["latest_time_change"].toDate().month.toString() +
            "/" +
            query.data()["latest_time_change"].toDate().year.toString(),
        style: Theme.of(context).textTheme.subtitle1,
      );
    }
  }
}

class PatientRecordDetials extends StatelessWidget {
  final String patient_Id;
  final String historyId;

  const PatientRecordDetials({Key key, this.patient_Id, this.historyId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: CustomColors.primaryBlue,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Patients/$patient_Id/History")
            .doc(historyId)
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
                padding: EdgeInsets.all(7.0),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  Center(
                    child: Container(
                      child: getDate(snapshot.data, context),
                    ),
                  ),
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
                        style: Theme.of(context).textTheme.headline6,
                      )),
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
                      style: Theme.of(context).textTheme.headline6,
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
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ListTile(
                    title: Text(
                      "COVID Condition: ",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      snapshot.data.data()["covid"],
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ListTile(
                    title: Text(
                      "Co-Morbid Conditions: ",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      snapshot.data.data()["coMorbid"],
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ListTile(
                    title: Text(
                      "Vaccine given: ",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      snapshot.data.data()["vaccine"],
                      style: Theme.of(context).textTheme.headline6,
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

  Text getDate(DocumentSnapshot query, BuildContext context) {
    DateTime created = query.data()["latest_time_change"].toDate();
    DateTime now = DateTime.now();
    Duration duration = now.difference(created);
    if (duration.inDays == 0) {
      return Text(
        "Today",
        style: Theme.of(context).textTheme.headline6,
      );
    } else if (duration.inDays == 1) {
      return Text(
        "Yesterday",
        style: Theme.of(context).textTheme.headline6,
      );
    } else if (duration.inDays == 2) {
      return Text(
        "Day before yesterday",
        style: Theme.of(context).textTheme.headline6,
      );
    } else {
      return Text(
        query.data()["latest_time_change"].toDate().day.toString() +
            "/" +
            query.data()["latest_time_change"].toDate().month.toString() +
            "/" +
            query.data()["latest_time_change"].toDate().year.toString(),
        style: Theme.of(context).textTheme.headline6,
      );
    }
  }
}
