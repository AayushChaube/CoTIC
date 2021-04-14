import 'dart:async';

import 'package:covidtracer/Services/hospital_auth_services.dart';
import 'package:covidtracer/hospital_pages/hospital_registration_page/hospital_register_model.dart';
import 'package:flutter/cupertino.dart';

class HospitalRegisterBloc {
  final HospitalAuthBase auth;

  HospitalRegisterBloc({@required this.auth});

  final StreamController<HospitalRegisterModel> _modelController =
      StreamController<HospitalRegisterModel>();
  Stream<HospitalRegisterModel> get modelStream => _modelController.stream;

  HospitalRegisterModel _model = HospitalRegisterModel();

  void dispose() {
    _modelController.close();
  }

  Future<void> submit() async {
    try {
      await auth.createUserWithEmailAndPassword(
          _model.email, _model.password, _model.prn, _model.name);
    } catch (e) {
      rethrow;
    }
  }

  void updateWith({
    String prn,
    String name,
    String email,
    String password,
    bool isObscure,
  }) {
    _model = _model.copyWith(
      prn: prn,
      name: name,
      email: email,
      password: password,
      isObscure: isObscure,
    );
    _modelController.add(_model);
  }
}
