import 'package:shared_preferences/shared_preferences.dart';

bool isHealthWorker;
String email;
String password;
String id;

Future<void> saveData(String key, String value) async {
  final _prefs = await SharedPreferences.getInstance();
  _prefs.setString(key, value ?? "");
  print("$key : $value saved");
}

Future<String> getData(String key) async {
  final _prefs = await SharedPreferences.getInstance();
  try {
    print("get Data: " + _prefs.getString(key));
    return _prefs.getString(key) ?? "";
  } catch (e) {
    print(e);
    return null;
  }
}

Future<void> saveBool(String key, bool value) async {
  final _prefs = await SharedPreferences.getInstance();
  _prefs.setBool(key, value ?? false);
  print("$key : $value saved");
}

Future<bool> getBool(String key) async {
  final _prefs = await SharedPreferences.getInstance();
  try {
    print("Get Bool: " + _prefs.getBool(key).toString());
    return _prefs.getBool(key) ?? false;
  } catch (e) {
    print(e);
    return null;
  }
}
