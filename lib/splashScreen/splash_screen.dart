import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rideshare_driver/mainScreens/main_screen.dart';
import 'package:rideshare_driver/authentication/login_screen.dart';
import 'package:rideshare_driver/global/global.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});
  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer(){
    Timer(const Duration(seconds: 3), () async {

      //check if user already logged in or not
      if(await fAuth.currentUser != null){
        currentFirebaseUser = fAuth.currentUser;
        //Send user to Main Screen page
        Navigator.push(context, MaterialPageRoute(builder: (c)=> MainScreen()));
      } else {
        //Send user to Login screen Page
        Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
      }
    }); //Timer
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/logo2.png"),

              const SizedBox(height: 10,),

              const Text(
                "Ride Share for Drivers!",
                style: TextStyle(
                  fontSize: 30,
                  color: Color(0xFFff725e),
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
