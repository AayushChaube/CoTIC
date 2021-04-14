import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidtracer/hospital_pages/assign_vaccine_to_health_worker.dart';
import 'package:covidtracer/themes/custom_colors.dart';
import 'package:covidtracer/widgets/showLoading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AssignVaccinePagee extends StatefulWidget {
  final String healthWorkerId;

  const AssignVaccinePagee({Key key, this.healthWorkerId}) : super(key: key);

  @override
  _AssignVaccinePageeState createState() => _AssignVaccinePageeState();
}

class _AssignVaccinePageeState extends State<AssignVaccinePagee> {
  final TextEditingController assignStock = TextEditingController();
  final TextEditingController zipCode = TextEditingController();
  bool _validate = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme:
            IconThemeData(color: Theme.of(context).scaffoldBackgroundColor),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Vaccines")
            .orderBy("created", descending: true)
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
              final String hospitalId = FirebaseAuth.instance.currentUser.uid;
              List<QueryDocumentSnapshot> query = snapshot.data.docs;
              query.removeWhere(
                  (element) => element.data()["hospital_id"] != hospitalId);
              query.removeWhere(
                (element) =>
                    DateTime.now()
                        .difference(element.data()["created"].toDate())
                        .inDays >
                    0,
              );
              if (query.isEmpty) {
                return Center(
                  child: Text(
                    "No Vaccines Created",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                );
              }
              return ListView.separated(
                itemCount: query.length,
                padding: EdgeInsets.all(10.0),
                separatorBuilder: (context, index) => SizedBox(height: 7.0),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5.0,
                    child: ListTile(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AssignVaccineToHealth(
                            healthWorkerId: widget.healthWorkerId,
                            vaccineId: query[index].id,
                            remainingVaccine:
                                query[index].data()["remaining_vaccine"],
                            vaccine_name: query[index].data()["vaccine_name"],
                          ),
                        ),
                      ),
                      title: Text(
                        query[index].data()["vaccine_name"],
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      subtitle: Text(
                        query[index].data()["created"].toDate().day.toString() +
                            "/" +
                            query[index]
                                .data()["created"]
                                .toDate()
                                .month
                                .toString() +
                            "/" +
                            query[index]
                                .data()["created"]
                                .toDate()
                                .year
                                .toString(),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            query[index].data()["remaining_vaccine"].toString(),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                      //leading: isAssigned(query, index),
                    ),
                  );
                },
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

  IconButton isAssigned(List<QueryDocumentSnapshot> query, int index) {
    return IconButton(
      icon: query[index].data()["assigned"] != widget.healthWorkerId
          ? Icon(Icons.check_circle_outline)
          : Icon(
              Icons.check_circle,
              color: CustomColors.FlutterBlue,
            ),
      onPressed: () async {
        if (query[index].data()["assigned"] != widget.healthWorkerId) {
          showLoading(context);
          await FirebaseFirestore.instance
              .collection("Vaccines")
              .doc(query[index].id)
              .update({
            "assigned": widget.healthWorkerId,
            "assigned_Date": DateTime.now()
          });
          Navigator.pop(context);
        } else {
          showLoading(context);
          await FirebaseFirestore.instance
              .collection("Vaccines")
              .doc(query[index].id)
              .update({
            "assigned": "",
            "assigned_Date": "",
          });
          Navigator.pop(context);
        }
      },
    );
  }
}
