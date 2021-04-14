import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidtracer/hospital_pages/add_health_worker_page/edit_health_worker_form.dart';
import 'package:flutter/material.dart';

import '../../../themes/custom_colors.dart';

class HealthWorkerDetailTab extends StatelessWidget {
  final String id;

  const HealthWorkerDetailTab({Key key, this.id}) : super(key: key);

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
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              return Scaffold(
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditHealthWorkerFormPage(id: id),
                    ),
                  ),
                ),
                body: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      snapshot.data["profile_image"] != null
                          ? Container(
                              height: 300,
                              width: 300,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    snapshot.data.data()["profile_image"],
                                    scale: 1.0,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : snapshot.data.data()["gender"] ==
                                  "I prefer not to say"
                              ? Container(
                                  height: 110,
                                  width: 110,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: CustomColors.primaryBlue,
                                  ),
                                )
                              : Container(
                                  height: 110,
                                  width: 110,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: CustomColors.primaryBlue,
                                      image: DecorationImage(
                                        image: snapshot.data.data()["gender"] ==
                                                "Male"
                                            ? AssetImage(
                                                "assets/images/health_worker_male_image.png",
                                              )
                                            : AssetImage(
                                                "assets/images/health_worker_female_image.png"),
                                      )),
                                ),
                      SizedBox(height: 30.0),
                      ListTile(
                        leading: Icon(Icons.person_outline_outlined),
                        title: Text(
                          snapshot.data.data()["first_name"] +
                              " " +
                              snapshot.data.data()["last_name"],
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      SizedBox(height: 7.0),
                      ListTile(
                        leading: Icon(Icons.email_outlined),
                        title: Text(
                          snapshot.data.data()["email"],
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      SizedBox(height: 7.0),
                      ListTile(
                        leading: Icon(Icons.call_outlined),
                        title: Text(
                          snapshot.data.data()["mobile"].toString(),
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      SizedBox(height: 7.0),
                      ListTile(
                        leading: Icon(Icons.timer),
                        title: Text(
                          snapshot.data
                                  .data()["created_At"]
                                  .toDate()
                                  .day
                                  .toString() +
                              " / " +
                              snapshot.data
                                  .data()["created_At"]
                                  .toDate()
                                  .month
                                  .toString() +
                              " / " +
                              snapshot.data
                                  .data()["created_At"]
                                  .toDate()
                                  .year
                                  .toString(),
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      SizedBox(height: 7.0),
                      ListTile(
                        leading: Icon(Icons.person_outline),
                        title: Text(
                          snapshot.data.data()["gender"],
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ],
                  ),
                ),
              );

            default:
              return Center(child: CircularProgressIndicator());
          }
        });
  }
}
