import 'package:covidtracer/Services/hospital_auth_services.dart';
import 'package:covidtracer/hospital_pages/forgot_password_page/hospital_forgot_password.dart';
import 'package:covidtracer/hospital_pages/hospital_registration_page/create_hospital_signup_page.dart';
import 'package:covidtracer/themes/custom_colors.dart';
import 'package:covidtracer/widgets/custom_button.dart';
import 'package:covidtracer/widgets/showAlertDialog.dart';
import 'package:covidtracer/widgets/showLoading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'hospital_login_bloc.dart';
import 'hospital_login_model.dart';

class HospitalLogin extends StatefulWidget {
  final HospitalLoginBloc bloc;

  const HospitalLogin({this.bloc});

  static Widget create(BuildContext context) {
    final auth = Provider.of<HospitalAuthBase>(context, listen: false);
    return Provider<HospitalLoginBloc>(
      create: (_) => HospitalLoginBloc(auth: auth),
      child: Consumer<HospitalLoginBloc>(
        builder: (_, bloc, __) => HospitalLogin(bloc: bloc),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  _HospitalLoginState createState() => _HospitalLoginState();
}

class _HospitalLoginState extends State<HospitalLogin> {
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _passwordFocusNode = FocusNode();

  Future<void> _submit() async {
    try {
      showLoading(context);
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showAlertDialog(context, title: "Sign In Failed", content: e.message);
    } on PlatformException catch (e) {
      Navigator.pop(context);
      showAlertDialog(context, title: "Sign In Failed", content: e.message);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      body: StreamBuilder<HospitalLoginModel>(
          stream: widget.bloc.modelStream,
          initialData: HospitalLoginModel(),
          builder: (context, snapshot) {
            final HospitalLoginModel model = snapshot.data;
            return Center(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 20.0,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 30.0),
                    Text(
                      "Hospital Login",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline4.copyWith(
                            color: CustomColors.primaryBlue,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 30.0),
                    hospitalEmailInput(),
                    SizedBox(height: 15.0),
                    hospitalPasswordInput(model: model),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    ForgotPassword.create(context))),
                        child: Text(
                          "Forgot Password?",
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                color: CustomColors.primaryBlue,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(height: 7.0),
                    CustomButton(
                      desktopMaxWidth: MediaQuery.of(context).size.width / 1.0,
                      buttonHeight: 60.0,
                      buttonTitle: "Login",
                      buttonColor: CustomColors.primaryBlue,
                      textColor: Colors.white,
                      buttonRadius: 3.0,
                      onPressed: _submit,
                    ),
                    SizedBox(
                      height: 7.0,
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              CreateHospitalSignupPage.create(context),
                        ),
                      ),
                      child: Text(
                        "Don't have an account? Register",
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              color: CustomColors.primaryBlue,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  TextField hospitalPasswordInput({@required HospitalLoginModel model}) {
    return TextField(
      keyboardType: TextInputType.visiblePassword,
      controller: _passwordController,
      autocorrect: false,
      obscureText: model.isObscure,
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
          onPressed: () => widget.bloc.updateWith(isObscure: !model.isObscure),
          icon: model.isObscure
              ? Icon(Icons.visibility_off_outlined)
              : Icon(
                  Icons.visibility_outlined,
                ),
        ),
      ),
      onChanged: widget.bloc.updatePassword,
      focusNode: _passwordFocusNode,
      onEditingComplete: _submit,
      style: Theme.of(context)
          .textTheme
          .headline6
          .copyWith(fontWeight: FontWeight.normal),
    );
  }

  TextField hospitalEmailInput() {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      autocorrect: false,
      enableSuggestions: true,
      enableInteractiveSelection: true,
      textInputAction: TextInputAction.go,
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
      onChanged: widget.bloc.updateEmail,
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_passwordFocusNode),
      style: Theme.of(context)
          .textTheme
          .headline6
          .copyWith(fontWeight: FontWeight.normal),
    );
  }
}
