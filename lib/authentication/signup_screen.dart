import 'package:flutter/material.dart';
import 'package:rideshare_driver/authentication/car_info_screen.dart';
import 'package:rideshare_driver/authentication/login_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rideshare_driver/widgets/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rideshare_driver/global/global.dart';
import 'package:firebase_database/firebase_database.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm() {

    //RegExp passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    RegExp passwordUpperCaseRegex = RegExp(r'^(?=.*[A-Z])');
    RegExp passwordLowerCaseRegex = RegExp(r'^(?=.*[a-z])');
    RegExp passwordDigitRegex = RegExp(r'^(?=.*?[0-9])');
    RegExp passwordSpecialCharRegex = RegExp(r'^(?=.*?[!@#\$&*~])');

    if(nameTextEditingController.text.length < 3) {
      Fluttertoast.showToast(msg: "Name must be at least 3 Characters.");
    } else if(!emailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email is not valid");
    } else if(phoneTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Phone number is required");
    } else if(passwordTextEditingController.text.length < 8) {
      Fluttertoast.showToast(msg: "Password must be at least 8 characters");
    } else if (!passwordUpperCaseRegex.hasMatch(passwordTextEditingController.text)){
      Fluttertoast.showToast(msg: "Password must contain one Upper Case");
    } else if (!passwordLowerCaseRegex.hasMatch(passwordTextEditingController.text)){
      Fluttertoast.showToast(msg: "Password must contain one Lower Case");
    } else if (!passwordDigitRegex.hasMatch(passwordTextEditingController.text)){
      Fluttertoast.showToast(msg: "Password must contain one Digit");
    } else if (!passwordSpecialCharRegex.hasMatch(passwordTextEditingController.text)){
      Fluttertoast.showToast(msg: "Password must contain one Special Character");
    } else {
      saveDriverInfoNow();
    }
  }

  saveDriverInfoNow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        //Progress Dialog
        builder: (BuildContext c) {
          return ProgressDialog(message: "Processing, Please wait...",);
        }
    );

    final User? firebaseUser = (
        await fAuth.createUserWithEmailAndPassword(
            email: emailTextEditingController.text.trim(),
            password: passwordTextEditingController.text.trim()
        ).catchError((err){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Error: " + err.toString());
        })
    ).user;

    if(firebaseUser != null) {
      Map driverMap = {
        "id": firebaseUser.uid,
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
      driversRef.child(firebaseUser.uid).set(driverMap);

      currentFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: "Account has been Created...");
      Navigator.push(context, MaterialPageRoute(builder: (c)=> CarInfoScreen()));


    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Account has not been Created...");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2727),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [

              const SizedBox(height: 10,),

              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Image.asset("images/logo5.png"),
              ),

              const SizedBox(height: 10,),

              //Register as a Driver
              const Text(
                "Register as a Driver",
                style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
              ),

              const SizedBox(height: 20,),

              //Name Field
              TextField(
                controller: nameTextEditingController,
                style: const TextStyle(
                  color: Color(0xFFB0BEC5),
                ),
                decoration: const InputDecoration(
                  labelText: "Name",
                  hintText: "Name",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFff725e))
                  ),

                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                  ),
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Color(0xFFff725e),
                    fontSize: 15,
                  ),


                ),
              ),

              //Email
              TextField(
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  color: Color(0xFFB0BEC5),
                ),
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Email",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFff725e))
                  ),

                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                  ),
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Color(0xFFff725e),
                    fontSize: 15,
                  ),


                ),
              ),

              //Phone
              TextField(
                controller: phoneTextEditingController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(
                  color: Color(0xFFB0BEC5),
                ),
                decoration: const InputDecoration(
                  labelText: "Phone",
                  hintText: "Phone",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFff725e))
                  ),

                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                  ),
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Color(0xFFff725e),
                    fontSize: 15,
                  ),


                ),
              ),

              //Password
              TextField(
                controller: passwordTextEditingController,
                keyboardType: TextInputType.text,
                obscureText: true,
                style: const TextStyle(
                  color: Color(0xFFB0BEC5),
                ),
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Password",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFff725e))
                  ),

                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                  ),
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Color(0xFFff725e),
                    fontSize: 15,
                  ),


                ),
              ),

              const SizedBox(height: 20,),

              // Create Account Button
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    validateForm();
                    //Navigator.push(context, MaterialPageRoute(builder: (c)=> CarInfoScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFff725e),
                  ),
                  child: const Text(
                    "Create Account",
                    style: TextStyle(
                      color: Color(0xFF1a2e35),
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20,),

              //Already have an account? Login here
              TextButton(
                child: const Text(
                  "Already have an account? Login Here!",
                  style: TextStyle(
                    color: Colors.white24,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
