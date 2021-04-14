import 'dart:async';

import 'package:covidtracer/Services/hospital_auth_services.dart';
import 'package:flutter/material.dart' show required;

import 'hospital_login_model.dart';

class HospitalLoginBloc {
  HospitalLoginBloc({
    @required this.auth,
  });

  final HospitalAuthBase auth;
  final StreamController<HospitalLoginModel> _modelController =
      StreamController<HospitalLoginModel>();

  Stream<HospitalLoginModel> get modelStream => _modelController.stream;
  HospitalLoginModel _model = HospitalLoginModel();

  void dispose() {
    _modelController.close();
  }

  Future<void> submit() async {
    try {
      await auth.signInWithEmailAndPassword(_model.email, _model.password);
    } catch (e) {
      rethrow;
    }
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateWith({
    String email,
    String password,
    bool isObscure,
  }) {
    //update Modeel
    //add updated model to StreamController
    _model = _model.copyWith(
      email: email,
      password: password,
      isObscure: isObscure,
    );
    _modelController.add(_model);
  }
}
