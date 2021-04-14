import 'package:covidtracer/Services/hospital_auth_services.dart';
import 'package:covidtracer/hospital_pages/forgot_password_page/forgot_password_bloc.dart';
import 'package:covidtracer/hospital_pages/forgot_password_page/forgot_password_model.dart';
import 'package:covidtracer/hospital_pages/hospital_registration_page/create_hospital_signup_page.dart';
import 'package:covidtracer/themes/custom_colors.dart';
import 'package:covidtracer/widgets/custom_button.dart';
import 'package:covidtracer/widgets/showAlertDialog.dart';
import 'package:covidtracer/widgets/showLoading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgotPassword extends StatefulWidget {
  final HospitalPasswordBloc bloc;
  ForgotPassword({this.bloc});
  static Widget create(BuildContext context) {
    final auth = Provider.of<HospitalAuthBase>(context, listen: false);
    return Provider(
      create: (_) => HospitalPasswordBloc(auth: auth),
      child: Consumer<HospitalPasswordBloc>(
        builder: (_, bloc, __) => ForgotPassword(
          bloc: bloc,
        ),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _emailController = TextEditingController();

  Future<void> _submit() async {
    try {
      showLoading(context);
      widget.bloc.submit();
      Navigator.of(context).pop();
      showAlertDialog(context,
          title: "Password Reset",
          content: "Password Reset link is sent on your email");
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showAlertDialog(context, title: "Error", content: e.message);
      _emailController.clear();
    } on PlatformException catch (e) {
      Navigator.pop(context);
      showAlertDialog(context, title: "Error", content: e.message);
    }
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
      body: StreamBuilder<HospitalPasswordModel>(
          stream: widget.bloc.modelStream,
          initialData: HospitalPasswordModel(),
          builder: (context, snapshot) {
            final HospitalPasswordModel model = HospitalPasswordModel();
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
                      "Hospital Forgot Password",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline4.copyWith(
                            color: CustomColors.primaryBlue,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 30.0),
                    hospitalEmailInput(),
                    SizedBox(
                      height: 20.0,
                    ),
                    CustomButton(
                      desktopMaxWidth: MediaQuery.of(context).size.width / 1.0,
                      buttonHeight: 60.0,
                      buttonTitle: "Send me the link",
                      buttonColor: CustomColors.primaryBlue,
                      textColor: Colors.white,
                      buttonRadius: 3.0,
                      onPressed: _submit,
                    ),
                    SizedBox(
                      height: 7.0,
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pushReplacement(
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
      onEditingComplete: _submit,
      style: Theme.of(context).textTheme.headline6,
    );
  }
}
