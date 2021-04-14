import 'package:covidtracer/Services/sharedprefs_helper.dart';
import 'package:covidtracer/hospital_pages/add_health_worker_page/health_worker_page.dart';
import 'package:covidtracer/hospital_pages/add_vaccine_page/add_vaccine_page.dart';
import 'package:covidtracer/hospital_pages/covid_stats_api.dart';
import 'package:covidtracer/hospital_pages/post_page/post_page.dart';
import 'package:covidtracer/hospital_pages/profile_page/hospital_profile_page.dart';
import 'package:covidtracer/themes/custom_colors.dart';
import 'package:covidtracer/widgets/bottom_bar/bottom_bar.dart';
import 'package:covidtracer/widgets/bottom_bar/bottom_bar_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HospitalHomePage extends StatefulWidget {
  @override
  _HospitalHomePageState createState() => _HospitalHomePageState();
}

class _HospitalHomePageState extends State<HospitalHomePage> {
  int selectedBarIndex = 0;

  @override
  void initState() {
    if (isHealthWorker == true) {
      FirebaseAuth.instance.signOut();
    }
    super.initState();
  }

  final List<BottomBarItem> _bottomBarList = [
    BottomBarItem(
      icon: Icon(Icons.dashboard),
      title: Text("Posts"),
      screen: PostPage(),
    ),
    BottomBarItem(
      icon: Icon(Icons.person_add),
      title: Text("Add Worker"),
      screen: HealthWorkerPage(),
    ),
    BottomBarItem(
      icon: Icon(Icons.medical_services_outlined),
      title: Text("Add Vaccine"),
      screen: AddVaccinePage(),
    ),
    BottomBarItem(
      icon: Icon(Icons.account_circle),
      title: Text("Profile"),
      screen: HospitalProfilePage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: CustomColors.primaryBlue,
        title: Text(
          "Hospital",
          style: Theme.of(context).textTheme.headline6.copyWith(
                color: Colors.white,
              ),
        ),
        centerTitle: true,
      ),
      drawer: _appDrawer(),
      body: _bottomBarList[selectedBarIndex].screen,
      bottomNavigationBar: BottomBar(
        items: _bottomBarList,
        currentIndex: selectedBarIndex,
        onTap: (int i) {
          setState(() {
            selectedBarIndex = i;
          });
        },
      ),
    );
  }
}

// ignore: camel_case_types
class _appDrawer extends StatelessWidget {
  Future<void> _confirmSignOut(BuildContext context) async {
    final bool didRequest = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure you wish to Logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Yes"),
          ),
        ],
      ),
    );
    if (didRequest == true) {
      FirebaseAuth.instance.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text(
              "CoTIC",
              style: Theme.of(context).textTheme.headline2.copyWith(
                    color: CustomColors.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Divider(thickness: 1.0),
          ListTile(
            leading: Text(
              "COVID Stats",
              style: Theme.of(context).textTheme.headline6,
            ),
            trailing: Icon(Icons.trending_up),
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => CovidStatsApi())),
          ),
          Divider(thickness: 1.0),
          ListTile(
            leading: Text(
              "Sign out",
              style: Theme.of(context).textTheme.headline6,
            ),
            trailing: Icon(Icons.logout),
            onTap: () => _confirmSignOut(context),
          ),
          Divider(thickness: 1.0),
        ],
      ),
    );
  }
}
