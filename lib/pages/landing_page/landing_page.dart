import 'package:covidtracer/Services/sharedprefs_helper.dart';
import 'package:covidtracer/health_worker_pages/home_page/heath_worker_home_page.dart';
import 'package:covidtracer/pages/login_page/login_page.dart';
import 'package:covidtracer/themes/custom_colors.dart';
import 'package:covidtracer/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2.0,
                color: Color(0xFF5347E9),
                padding: EdgeInsets.only(top: 30),
                child: Image.network(
                  "https://cdn.dribbble.com/users/2417352/screenshots/11194926/media/0d9cd4a0298263ac2eb1047afb0aaaa7.jpg?compress=1&resize=800x600",
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Let's get started",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline4.copyWith(
                            color: CustomColors.primaryBlue,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 30.0),
                    CustomButton(
                      desktopMaxWidth: MediaQuery.of(context).size.width / 1.1,
                      buttonHeight: 55.0,
                      buttonTitle: "Login with Email",
                      buttonColor: CustomColors.primaryBlue,
                      textColor: Colors.white,
                      buttonRadius: 3.0,
                      onPressed: () {
                        if (isHealthWorker == true) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => HeathWorkerHomePage(),
                            ),
                            ModalRoute.withName('/'),
                          );
                        } else {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
