import 'package:covidtracer/Services/hospital_auth_services.dart';
import 'package:covidtracer/hospital_pages/home_page/hospital_home_page.dart';
import 'package:covidtracer/hospital_pages/login_page/hospital_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HospitalLandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<HospitalAuthBase>(context, listen: false);
    return StreamBuilder<User>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        User user = snapshot.data;
        if (user == null) {
          return HospitalLogin.create(context);
        }
        return HospitalHomePage();
      },
    );
  }
}
