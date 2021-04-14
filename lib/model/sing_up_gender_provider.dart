import 'package:flutter/material.dart' show ChangeNotifier;

class UserSignUpGenderProvider with ChangeNotifier {
  String selectedGenderNotation = "m";

  String get selectedGenderValue => selectedGenderNotation;

  changeValue(String value) {
    selectedGenderNotation = value;
    notifyListeners();
  }
}
