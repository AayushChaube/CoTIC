import 'dart:async';

import 'package:covidtracer/Services/hospital_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'forgot_password_model.dart';

class HospitalPasswordBloc {
  HospitalPasswordBloc({@required this.auth});

  final HospitalAuthBase auth;

  final StreamController<HospitalPasswordModel> _modelController =
      StreamController<HospitalPasswordModel>();

  Stream<HospitalPasswordModel> get modelStream => _modelController.stream;

  HospitalPasswordModel _model = HospitalPasswordModel();

  void dispose() {
    _modelController.close();
  }

  void updateEmail(String email) => updateWith(email: email);

  Future<void> submit() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _model.email);
    } catch (e) {
      rethrow;
    }
  }

  void updateWith({String email}) {
    _model = _model.copyWith(email: email);
    _modelController.add(_model);
  }
}
