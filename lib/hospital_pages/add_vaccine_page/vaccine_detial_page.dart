import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VaccineDetialPage extends StatelessWidget {
  final String vaccine_Id;
  VaccineDetialPage({this.vaccine_Id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Vaccine",
          style: Theme.of(context).textTheme.headline6,
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Vaccines")
            .doc(vaccine_Id)
            .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              return Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  children: [
                    SizedBox(height: 20.0),
                    Card(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      child: ListTile(
                        leading: Text(
                          "Vaccine Name:",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        title: Text(
                          snapshot.data.data()["vaccine_name"],
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Card(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      child: ListTile(
                        leading: Text(
                          "Vaccine Due Age:",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        title: Text(
                          snapshot.data.data()["due_Age"],
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Card(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      child: ListTile(
                        leading: Text(
                          "Vaccine Max Age:",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        title: Text(
                          snapshot.data.data()["max_Age"],
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Card(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      child: ListTile(
                        leading: Text(
                          "Vaccine Route:",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        title: Text(
                          snapshot.data.data()["route"],
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Card(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      child: ListTile(
                        leading: Text(
                          "Vaccine Site:",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        title: Text(
                          snapshot.data.data()["site"],
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Card(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      child: ListTile(
                        leading: Text(
                          "Remaining Stock:",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        title: Text(
                          snapshot.data.data()["remaining_vaccine"].toString() +
                              " units",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            default:
              return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
