class HospitalPasswordModel {
  final String email;

  HospitalPasswordModel({this.email = ""});

  HospitalPasswordModel copyWith({String email}) {
    return HospitalPasswordModel(email: email ?? this.email);
  }
}
