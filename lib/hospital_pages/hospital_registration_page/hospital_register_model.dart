class HospitalRegisterModel {
  final String prn;
  final String name;
  final String email;
  final String password;
  final bool isObscure;

  HospitalRegisterModel({
    this.prn = "",
    this.name = "",
    this.email = "",
    this.password = "",
    this.isObscure = true,
  });

  HospitalRegisterModel copyWith({
    String prn,
    String name,
    String email,
    String password,
    bool isObscure,
  }) {
    return HospitalRegisterModel(
      prn: prn ?? this.prn,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      isObscure: isObscure??this.isObscure,
    );
  }
}
