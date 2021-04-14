import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidtracer/Services/sharedprefs_helper.dart';
import 'package:covidtracer/health_worker_pages/covid_region_page/covid_region_page.dart';
import 'package:covidtracer/health_worker_pages/daily_task_page/daily_task_page.dart';
import 'package:covidtracer/health_worker_pages/patients_page/patient_page.dart';
import 'package:covidtracer/health_worker_pages/profile_page/health_worker_profile_page.dart';
import 'package:covidtracer/health_worker_pages/vaccine_stats_page/vaccine_stats_page.dart';
import 'package:covidtracer/hospital_pages/covid_stats_api.dart';
import 'package:covidtracer/pages/login_page/login_page.dart';
import 'package:covidtracer/themes/custom_colors.dart';
import 'package:covidtracer/widgets/bottom_bar/bottom_bar.dart';
import 'package:covidtracer/widgets/bottom_bar/bottom_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Services/sharedprefs_helper.dart';
import '../../widgets/custom_button.dart';

class HeathWorkerHomePage extends StatefulWidget {
  @override
  _HeathWorkerHomePageState createState() => _HeathWorkerHomePageState();
}

class _HeathWorkerHomePageState extends State<HeathWorkerHomePage> {
  int selectedBarIndex = 0;

  final List<BottomBarItem> _bottomBarList = [
    BottomBarItem(
      icon: Icon(Icons.dashboard),
      title: Text("Dashboard"),
      screen: CovidRegionPage(),
    ),
    BottomBarItem(
      icon: Icon(Icons.people),
      title: Text("Patients"),
      screen: PatientPage(),
    ),
    BottomBarItem(
      icon: Icon(Icons.assignment_turned_in_outlined),
      title: Text("Daily Task"),
      screen: DailyTaskPage(),
    ),
    BottomBarItem(
      icon: Icon(Icons.bar_chart),
      title: Text("Vaccine Stock"),
      screen: VaccineStatsPage(),
    ),
    BottomBarItem(
      icon: Icon(Icons.account_circle),
      title: Text("Profile"),
      screen: HealthWorkerProfilePage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(
          color: CustomColors.primaryBlue,
        ),
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
  const _appDrawer({
    Key key,
  }) : super(key: key);

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
              "Settings",
              style: Theme.of(context).textTheme.headline6,
            ),
            trailing: FaIcon(FontAwesomeIcons.cog),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SettingsPage(),
              ),
            ),
          ),
          Divider(thickness: 1.0),

          ListTile(
              leading: Text(
                "Sign out",
                style: Theme.of(context).textTheme.headline6,
              ),
              trailing: Icon(Icons.logout),
              onTap: () async {
                saveData("email", null);
                saveData("password", null);
                saveData("id", null);
                saveBool("isWorker", false);
                id = await getData("id");
                isHealthWorker = await getBool("isWorker");
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                  ModalRoute.withName('/'),
                );
              }),
          Divider(thickness: 1.0),
        ],
      ),
    );
  }
}

class UpdatePasswordPage extends StatefulWidget {
  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final TextEditingController controller1 = TextEditingController();

  final TextEditingController controller2 = TextEditingController();

  bool isObscure1 = true;

  bool isObscure2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.primaryBlue,
        title: Text(
          "Update Password",
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(15.0),
        children: [
          TextField(
            controller: controller1,
            obscureText: isObscure1,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () => setState(() => isObscure1 = !isObscure1),
                icon: isObscure1 == true
                    ? Icon(
                        Icons.visibility_outlined,
                      )
                    : Icon(Icons.visibility_off_outlined),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: controller2,
            obscureText: isObscure2,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () => setState(() => isObscure2 = !isObscure2),
                icon: isObscure2 == true
                    ? Icon(
                        Icons.visibility_outlined,
                      )
                    : Icon(Icons.visibility_off_outlined),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          CustomButton(
            desktopMaxWidth: MediaQuery.of(context).size.width / 1.0,
            buttonHeight: 60.0,
            buttonTitle: "Update Password",
            buttonColor: CustomColors.primaryBlue,
            textColor: Colors.white,
            buttonRadius: 3.0,
            onPressed: () async {
              if (controller1.text == controller2.text &&
                  controller1.text.isNotEmpty &&
                  controller2.text.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection("Health Workers")
                    .doc(id)
                    .update({
                  "password": controller2.text,
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Password updated"),
                ));
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Password does not match"),
                ));
              }
            },
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.primaryBlue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: EdgeInsets.all(15.0),
        children: [
          Card(
            elevation: 5.0,
            child: ListTile(
              leading: Text(
                "Update Password",
                style: Theme.of(context).textTheme.headline6,
              ),
              trailing: FaIcon(FontAwesomeIcons.lock),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UpdatePasswordPage(),
                ),
              ),
            ),
          ),
          Divider(thickness: 1.0),
        ],
      ),
    );
  }
}
