class HospitalLoginModel {
  final String email;
  final String password;
  final bool isObscure;

  HospitalLoginModel({
    this.email = "",
    this.password = "",
    this.isObscure = true,
  });

  HospitalLoginModel copyWith({
    String email,
    String password,
    bool isObscure,
  }) {
    return HospitalLoginModel(
      email: email ?? this.email,
      password: password ?? this.password,
      isObscure: isObscure ?? this.isObscure,
    );
  }
}
