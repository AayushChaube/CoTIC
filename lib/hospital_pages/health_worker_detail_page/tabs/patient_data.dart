import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidtracer/hospital_pages/health_worker_detail_page/patient_data_tab.dart';
import 'package:flutter/material.dart';

//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(

//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection("Patients")
//             .orderBy("created", descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.none:
//             case ConnectionState.waiting:
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             case ConnectionState.active:
//             case ConnectionState.done:
//               List<QueryDocumentSnapshot> query = snapshot.data.docs;
//               query.removeWhere((element) =>
//                   element.data()["health_worker_Id"] != healthWorkerId);
//               if (query.length == 0) {
//                 return Center(
//                   child: Text(
//                     "No Patient Data",
//                     style: Theme.of(context).textTheme.headline6,
//                   ),
//                 );
//               }
//               return ListView.builder(
//                 padding: EdgeInsets.all(8.0),
//                 itemCount: query.length,
//                 itemBuilder: (context, index) {
//                   return Card(
//                     margin: EdgeInsets.symmetric(vertical: 8.0),
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         radius: 30.0,
//                         backgroundImage:
//                             NetworkImage(query[index].data()["profile_image"]),
//                       ),
//                       onTap: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => PatientDataTab(
//                                 id: query[index].data()["patient_Id"])),
//                       ),
//                       contentPadding: EdgeInsets.symmetric(
//                         horizontal: 10.0,
//                         vertical: 7.0,
//                       ),
//                       title: Text(
//                         query[index].data()["patient_first_name"] +
//                             " " +
//                             query[index].data()["patient_last_name"],
//                         style: Theme.of(context).textTheme.headline6,
//                       ),
//                       subtitle: Text(
//                         query[index].data()["email"],
//                         style: Theme.of(context).textTheme.headline6,
//                       ),
//                     ),
//                   );
//                 },
//               );
//
//             default:
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//           }
//         },
//       ),
//     );
//   }
// }

class PatientData extends StatefulWidget {
  final String healthWorkerId;

  const PatientData({Key key, this.healthWorkerId}) : super(key: key);

  @override
  _PatientDataState createState() => _PatientDataState();
}

class _PatientDataState extends State<PatientData> {
  TextEditingController _searchController = TextEditingController();
  Future resultsLoaded;
  List<QueryDocumentSnapshot> _allResults = [];
  List _resultsList = [];

  @override
  void initState() {
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  _onSearchChanged() {
    searchResultsList();
    print(_searchController.text);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.clear();
    super.dispose();
  }

  getAllDoctorsList() async {
    var data = await FirebaseFirestore.instance
        .collection("Patients")
        .orderBy("latest_time_change", descending: true)
        .get();
    List<QueryDocumentSnapshot> query = data.docs;
    query.removeWhere((element) =>
        element.data()["health_worker_Id"] != widget.healthWorkerId);
    setState(() {
      _allResults = query;
    });
    searchResultsList();
    return "complete";
  }

  @override
  void didChangeDependencies() {
    resultsLoaded = getAllDoctorsList();
    super.didChangeDependencies();
  }

  searchResultsList() {
    var showResults = [];
    if (_searchController.text != "") {
      //We have search params
      for (var search in _allResults) {
        var title =
            search.data()["patient_first_name"].toString().toLowerCase() +
                " " +
                search.data()["patient_last_name"].toString().toLowerCase();
        if (title.contains(_searchController.text.toLowerCase())) {
          showResults.add(search);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => didChangeDependencies(),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 65.0,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  child: Center(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        hintText: "Search Patients",
                        hintStyle: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                _resultsList.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "No Patients present",
                            style: Theme.of(context).textTheme.headline6,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          scrollDirection: Axis.vertical,
                          itemCount: _resultsList.length,
                          itemBuilder: (context, index) => Card(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 7.0,
                              ),
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PatientDataTab(
                                      id: _resultsList[index].id),
                                ),
                              ),
                              leading: CircleAvatar(
                                radius: 30.0,
                                backgroundImage: NetworkImage(
                                    _resultsList[index]
                                        .data()["profile_image"]),
                              ),
                              title: Text(
                                _resultsList[index]
                                        .data()["patient_first_name"] +
                                    " " +
                                    _resultsList[index]
                                        .data()["patient_last_name"],
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
