import 'package:covidtracer/Services/hospital_auth_services.dart';
import 'package:covidtracer/hospital_pages/hospital_registration_page/hospital_register_bloc.dart';
import 'package:covidtracer/hospital_pages/hospital_registration_page/hospital_register_model.dart';
import 'package:covidtracer/themes/custom_colors.dart';
import 'package:covidtracer/widgets/custom_button.dart';
import 'package:covidtracer/widgets/showLoading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateHospitalSignupPage extends StatefulWidget {
  final HospitalRegisterBloc bloc;

  const CreateHospitalSignupPage({this.bloc});

  static Widget create(BuildContext context) {
    final auth = Provider.of<HospitalAuthBase>(context, listen: false);
    return Provider<HospitalRegisterBloc>(
      create: (_) => HospitalRegisterBloc(auth: auth),
      child: Consumer<HospitalRegisterBloc>(
          builder: (_, bloc, __) => CreateHospitalSignupPage(bloc: bloc)),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  _CreateHospitalSignupPageState createState() =>
      _CreateHospitalSignupPageState();
}

class _CreateHospitalSignupPageState extends State<CreateHospitalSignupPage> {
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();

  final FocusNode _emailFocusNode = FocusNode();

  final FocusNode _passwordFocusNode = FocusNode();

  Future<void> _submit() async {
    try {
      showLoading(context);
      await widget.bloc.submit();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Sign In Failed"),
          content: Text(e.message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Ok"),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _scrollController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: StreamBuilder<HospitalRegisterModel>(
          stream: widget.bloc.modelStream,
          initialData: HospitalRegisterModel(),
          builder: (context, snapshot) {
            final HospitalRegisterModel model = snapshot.data;
            return Center(
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 20.0,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 30.0),
                    Text(
                      "Hospital Registration",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline4.copyWith(
                            color: CustomColors.primaryBlue,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 30.0),
                    HospitalNumberInput(),
                    SizedBox(height: 15.0),
                    HospitalNameInput(),
                    SizedBox(height: 15.0),
                    HospitalEmailInput(),
                    SizedBox(height: 15.0),
                    HospitalPasswordInput(model: model),
                    SizedBox(height: 7.0),
                    CustomButton(
                      desktopMaxWidth: MediaQuery.of(context).size.width / 1.0,
                      buttonHeight: 60.0,
                      buttonTitle: "Register",
                      buttonColor: CustomColors.primaryBlue,
                      textColor: Colors.white,
                      buttonRadius: 3.0,
                      onPressed: _submit,
                    ),
                    SizedBox(
                      height: 7.0,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  TextField HospitalNameInput() {
    return TextField(
      keyboardType: TextInputType.name,
      controller: _nameController,
      autocorrect: false,
      focusNode: _nameFocusNode,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        enabledBorder: OutlineInputBorder(),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        hintText: "Hospital Name (Required)",
        hintStyle: TextStyle(color: Colors.black54),
      ),
      onChanged: (String name) => widget.bloc.updateWith(name: name),
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_emailFocusNode),
      style: Theme.of(context).textTheme.headline6,
    );
  }

  TextField HospitalNumberInput() {
    return TextField(
      keyboardType: TextInputType.number,
      controller: _numberController,
      autocorrect: false,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        enabledBorder: OutlineInputBorder(),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        hintText: "Hospital PRN Number (Required)",
        hintStyle: TextStyle(color: Colors.black54),
      ),
      onChanged: (String prn) => widget.bloc.updateWith(prn: prn),
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_nameFocusNode),
      style: Theme.of(context).textTheme.headline6,
    );
  }

  TextField HospitalPasswordInput({HospitalRegisterModel model}) {
    return TextField(
      keyboardType: TextInputType.visiblePassword,
      controller: _passwordController,
      autocorrect: false,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        enabledBorder: OutlineInputBorder(),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        hintText: "Password (Required)",
        hintStyle: TextStyle(color: Colors.black54),
        suffixIcon: IconButton(
          icon: model.isObscure == true
              ? Icon(Icons.visibility_outlined)
              : Icon(Icons.visibility_off_outlined),
          onPressed: () => widget.bloc.updateWith(isObscure: !model.isObscure),
        ),
      ),
      obscureText: model.isObscure,
      onChanged: (String password) =>
          widget.bloc.updateWith(password: password),
      focusNode: _passwordFocusNode,
      onEditingComplete: _submit,
      style: Theme.of(context).textTheme.headline6,
    );
  }

  TextField HospitalEmailInput() {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      autocorrect: false,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        enabledBorder: OutlineInputBorder(),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        hintText: "E-mail (Required)",
        hintStyle: TextStyle(color: Colors.black54),
      ),
      onChanged: (String email) => widget.bloc.updateWith(email: email),
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_passwordFocusNode),
      style: Theme.of(context).textTheme.headline6,
    );
  }
}
