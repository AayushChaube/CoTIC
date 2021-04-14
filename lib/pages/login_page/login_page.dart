import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidtracer/Services/sharedprefs_helper.dart';
import 'package:covidtracer/health_worker_pages/home_page/heath_worker_home_page.dart';
import 'package:covidtracer/hospital_pages/hospital_landing_page.dart';
import 'package:covidtracer/themes/custom_colors.dart';
import 'package:covidtracer/widgets/custom_button.dart';
import 'package:covidtracer/widgets/custom_outline_button.dart';
import 'package:covidtracer/widgets/showAlertDialog.dart';
import 'package:covidtracer/widgets/showLoading.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final FocusNode passwordFocusNode = FocusNode();
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          controller: _scrollController,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          children: [
            SizedBox(
              height: 100,
            ),
            Text(
              "CoTIC",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4.copyWith(
                    color: CustomColors.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 5.0),
            Center(
              child: Text(
                "Log into your account",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            SizedBox(height: 50.0),
            emailInput(),
            SizedBox(height: 15.0),
            passwordInput(),
            SizedBox(height: 15.0),
            CustomButton(
              desktopMaxWidth: MediaQuery.of(context).size.width / 1.0,
              buttonHeight: 60.0,
              buttonTitle: "Login in",
              buttonColor: CustomColors.primaryBlue,
              textColor: Colors.white,
              buttonRadius: 3.0,
              onPressed: submit,
            ),
            SizedBox(height: 15.0),
            CustomOutlineButton(
              desktopMaxWidth: MediaQuery.of(context).size.width / 1.0,
              buttonHeight: 60.0,
              buttonTitle: "Login as Hospital",
              borderColor: CustomColors.primaryBlue,
              buttonBorderWidth: 2.0,
              textColor: CustomColors.primaryBlue,
              buttonRadius: 3.0,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HospitalLandingPage(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submit() async {
    try {
      showLoading(context);
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("Health Workers").get();
      List<QueryDocumentSnapshot> docs = querySnapshot.docs;
      docs.removeWhere(
          (element) => element.data()["email"] != _emailController.text);
      if (docs.isEmpty) {
        Navigator.pop(context);
        return showAlertDialog(
          context,
          title: "Email not found",
          content: "There is no user record corresponding to this email",
        );
      } else {
        print(docs.first.data());
        if (docs.first.data()["password"] != _passwordController.text) {
          Navigator.pop(context);
          return showAlertDialog(
            context,
            title: "Password is wrong",
            content:
                "The password you entered does not match to this email account",
          );
        } else {
          saveData("email", _emailController.text);
          saveData("password", _passwordController.text);
          saveData("id", docs.first.id);
          saveBool("isWorker", true);
          id = await getData("id");
          isHealthWorker = await getBool("isWorker");
          Navigator.pop(context);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => HeathWorkerHomePage(),
            ),
            ModalRoute.withName('/'),
          );
        }
      }
    } on FirebaseException catch (e) {
      Navigator.pop(context);
      showAlertDialog(
        context,
        title: "Error",
        content: e.message,
      );
      Navigator.of(context).pop();
    } catch (e) {
      Navigator.pop(context);
      showAlertDialog(
        context,
        title: "Error",
        content: e.toString(),
      );
      Navigator.of(context).pop();
    }
  }

  TextField passwordInput() {
    return TextField(
      controller: _passwordController,
      autocorrect: false,
      focusNode: passwordFocusNode,
      obscureText: isObscure,
      onEditingComplete: submit,
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
          onPressed: () => setState(() => isObscure = !isObscure),
          icon: isObscure
              ? Icon(Icons.visibility_off_outlined)
              : Icon(
                  Icons.visibility_outlined,
                ),
        ),
      ),
      style: Theme.of(context)
          .textTheme
          .headline6
          .copyWith(fontWeight: FontWeight.normal),
    );
  }

  TextField emailInput() {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      autocorrect: false,
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(passwordFocusNode),
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
      style: Theme.of(context)
          .textTheme
          .headline6
          .copyWith(fontWeight: FontWeight.normal),
    );
  }
}
