import 'dart:async';

import 'package:covidtracer/Services/sharedprefs_helper.dart';
import 'package:covidtracer/pages/landing_page/landing_page.dart';
import 'package:covidtracer/themes/custom_colors.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  startTime() async {
    var _duration = Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LandingPage()),
      );

  @override
  void initState() {
    super.initState();
    startTime();
    getDataId();
  }

  void getDataId() async {
    email = await getData("email");
    password = await getData("password");
    id = await getData("id");
    isHealthWorker = await getBool("isWorker");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Text(
          "CoTIC",
          style: Theme.of(context).textTheme.headline3.copyWith(
                color: CustomColors.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
