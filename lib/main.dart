import 'package:covidtracer/Services/hospital_auth_services.dart';
import 'package:covidtracer/health_worker_pages/add_patient_form_page/widget/comorbid_dropdown.dart';
import 'package:covidtracer/health_worker_pages/add_patient_form_page/widget/covid_condition_dropdown.dart';
import 'package:covidtracer/health_worker_pages/add_patient_form_page/widget/covid_status_dropdown.dart';
import 'package:covidtracer/health_worker_pages/add_patient_form_page/widget/gender_dropdown.dart';
import 'package:covidtracer/health_worker_pages/add_patient_form_page/widget/symptoms_dropdown.dart';
import 'package:covidtracer/health_worker_pages/add_patient_form_page/widget/vaccine_assign.dart';
import 'package:covidtracer/pages/splash_page/splash_page.dart';
import 'package:covidtracer/services/hospital_database_services.dart';
import 'package:covidtracer/themes/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:provider/provider.dart'
    show ChangeNotifierProvider, MultiProvider, Provider;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) async {
    await Firebase.initializeApp();
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CoMorbidValueProvider()),
          ChangeNotifierProvider(create: (_) => GenderProvider()),
          ChangeNotifierProvider(create: (_) => CoVidConditionValueProvider()),
          ChangeNotifierProvider(create: (_) => CovidStatusProvider()),
          ChangeNotifierProvider(create: (_) => SymptomProvider()),
          ChangeNotifierProvider(create: (_) => VaccineAssignProvider()),
          Provider<HospitalAuthBase>(create: (context) => HospitalAuth()),
          Provider<HospitalDatabaseBase>(
              create: (context) => HospitalDatabase()),
        ],
        builder: (context, snapshot) {
          return MaterialApp(
            title: "CoTIC",
            theme: Themes.lightTheme,
            home: SplashPage(),
          );
        });
  }
}
