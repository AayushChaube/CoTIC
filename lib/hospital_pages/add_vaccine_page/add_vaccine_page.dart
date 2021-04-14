import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidtracer/hospital_pages/add_vaccine_page/addVaccine_Detial_Page_With_Edit.dart';
import 'package:covidtracer/hospital_pages/add_vaccine_page/add_vaccine_form_page.dart';
import 'package:covidtracer/themes/custom_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddVaccinePage extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddVaccineFormPage(),
          ),
        ),
        backgroundColor: CustomColors.primaryBlue,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: StreamBuilder<QuerySnapshot>(
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
                  final String hosptialId =
                      FirebaseAuth.instance.currentUser.uid;
                  List<QueryDocumentSnapshot> query = snapshot.data.docs;
                  query.removeWhere(
                      (element) => element.data()["hospital_id"] != hosptialId);
                  if (query.isEmpty) {
                    return Center(
                      child: Text(
                        "No Vaccines Created",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    );
                  }
                  return Scrollbar(
                    controller: _scrollController,
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      physics: BouncingScrollPhysics(),
                      itemCount: query.length,
                      itemBuilder: (context, index) => Card(
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        elevation: 3.0,
                        child: ListTile(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddVaccineDetialPageWithEdit(
                                vaccine_Id: query[index].id,
                              ),
                            ),
                          ),
                          title: Text(
                            query[index].data()["vaccine_name"],
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          // SizedBox(height: 5.0),
                          // getVaccineCreatedDate(query, index, context),
                          subtitle:
                              getVaccineCreatedDate(query, index, context),
                          trailing: Text(
                            query[index]
                                    .data()["remaining_vaccine"]
                                    .toString() +
                                " units",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
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
  }

  Text getVaccineCreatedDate(
      List<QueryDocumentSnapshot> query, int index, BuildContext context) {
    DateTime date = query[index].data()["created"].toDate();
    return Text(
      date.day.toString() +
          "-" +
          date.month.toString() +
          "-" +
          date.year.toString(),
      style: Theme.of(context).textTheme.headline6,
    );
  }
}
