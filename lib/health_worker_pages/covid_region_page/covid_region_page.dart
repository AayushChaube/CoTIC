import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidtracer/Services/sharedprefs_helper.dart';
import 'package:flutter/material.dart';

class CovidRegionPage extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Posts")
            .orderBy("created", descending: true)
            .snapshots(),
        builder: (context, snapshots) {
          switch (snapshots.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              List<QueryDocumentSnapshot> query = snapshots.data.docs;
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection("Health Workers")
                    .doc(id)
                    .get(),
                builder: (context, document) {
                  switch (document.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    case ConnectionState.active:
                    case ConnectionState.done:
                      query.removeWhere((element) =>
                          element.data()["hospital_Id"] !=
                          document.data.data()["hospital_Id"]);
                      if (query.length == 0) {
                        return Center(
                          child: Text(
                            "No Posts Availbale",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        );
                      }
                      return Scrollbar(
                        controller: _scrollController,
                        child: ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemCount: query.length,
                          padding: EdgeInsets.all(10.0),
                          itemBuilder: (context, index) => Container(
                            padding: EdgeInsets.all(10.0),
                            margin: EdgeInsets.symmetric(vertical: 5.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Text(
                              query[index].data()["posts"],
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                        ),
                      );
                    default:
                      return Center(child: CircularProgressIndicator());
                  }
                },
              );
            default:
              return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
