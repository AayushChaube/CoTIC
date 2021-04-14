import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidtracer/hospital_pages/add_health_worker_page/add_health_worker_form.dart';
import 'package:covidtracer/hospital_pages/health_worker_detail_page/health_worker_detail_page.dart';
import 'package:covidtracer/themes/custom_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HealthWorkerPage extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddHealthWorkerFormPage(),
          ),
        ),
        backgroundColor: CustomColors.primaryBlue,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Health Workers")
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
                final String hospitalId = FirebaseAuth.instance.currentUser.uid;
                query.removeWhere(
                  (element) => element.data()["hospital_Id"] != hospitalId,
                );

                if (query.isEmpty) {
                  return Center(
                    child: Text(
                      "No Health Workers created",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  );
                }
                return ListView.separated(
                  controller: _scrollController,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                  itemCount: query.length,
                  separatorBuilder: (context, index) => SizedBox(height: 0.3),
                  itemBuilder: (context, index) => Card(
                    child: Padding(
                      //padding: const EdgeInsets.all(5.0),
                      padding: const EdgeInsets.all(0.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30.0,
                          backgroundImage: query[index]
                                      .data()["profile_image"] ==
                                  null
                              ? query[index].data()["gender"] ==
                                      "I prefer not to say"
                                  ? null
                                  : query[index].data()["gender"] == "Male"
                                      ? AssetImage(
                                          "assets/images/health_worker_male_image.png")
                                      : AssetImage(
                                          "assets/images/health_worker_female_image.png")
                              : NetworkImage(
                                  query[index].data()["profile_image"]),
                        ),
                        title: Text(
                          query[index]["first_name"] +
                              " " +
                              query[index]["last_name"],
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                fontSize: 23.0,
                              ),
                        ),
                        subtitle: Text(
                          query[index]["email"],
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        trailing: IconButton(
                          onPressed: () => FirebaseFirestore.instance
                              .collection("Health Workers")
                              .doc(query[index].id)
                              .delete(),
                          icon: Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                        ),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                HealthWorkerDetailPage(id: query[index].id),
                          ),
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
    );
  }
}
