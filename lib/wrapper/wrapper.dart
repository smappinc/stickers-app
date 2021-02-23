import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_app/home/home.dart';
import 'package:web_app/onboarding_screen/onboarding_screen.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  bool isOnboardingShownAlready = false;
  
  @override
  void initState() {
    super.initState();
    checkIfOnboardingScreenShowAlready();
  }

  void checkIfOnboardingScreenShowAlready() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isOnboardingShownAlready = prefs.getBool("isOnboardingShownAlready") ?? false;
    if(!isOnboardingShownAlready)
    {
      prefs.setBool("isOnboardingShownAlready", true); 
      Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => OnBoardingPage()),(Route<dynamic> route) => false,);
    }
    else
    {
      Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => HomeScreen()),(Route<dynamic> route) => false,);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[900],
      child: Center(
        child: CircularProgressIndicator(
        ),
      ),  
    );
  }
}