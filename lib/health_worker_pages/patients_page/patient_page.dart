import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidtracer/Services/sharedprefs_helper.dart';
import 'package:covidtracer/health_worker_pages/add_patient_form_page/add_patient_form_page.dart';
import 'package:covidtracer/health_worker_pages/patients_page/patient_details_tab.dart';
import 'package:covidtracer/themes/custom_colors.dart';
import 'package:flutter/material.dart';

class PatientPage extends StatefulWidget {
  @override
  _PatientPageState createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
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
    query.removeWhere((element) => element.data()["health_worker_Id"] != id);
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: CustomColors.primaryBlue,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddPatientFormPage(),
            ),
          ),
          child: Icon(
            Icons.group_add_outlined,
            color: Colors.white,
          ),
        ),
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
                  height: 10.0,
                ),
                Expanded(
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
                            builder: (context) =>
                                PatientDetailsTab(id: _resultsList[index].id),
                          ),
                        ),
                        leading: CircleAvatar(
                          radius: 30.0,
                          backgroundImage: NetworkImage(
                              _resultsList[index].data()["profile_image"]),
                        ),
                        title: Text(
                          _resultsList[index].data()["patient_first_name"] +
                              " " +
                              _resultsList[index].data()["patient_last_name"],
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
