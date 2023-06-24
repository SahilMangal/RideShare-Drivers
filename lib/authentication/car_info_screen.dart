import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rideshare_driver/global/global.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rideshare_driver/splashScreen/splash_screen.dart';

class CarInfoScreen extends StatefulWidget {

  @override
  State<CarInfoScreen> createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {

  TextEditingController carModelTextEditingController = TextEditingController();
  TextEditingController carNumberTextEditingController = TextEditingController();
  TextEditingController carColorTextEditingController = TextEditingController();

  List<String> carTypeList = ["Car", "Car-XL", "Bike"];
  String? selectedCarType;

  saveCarInfo(){



    Map driverCarInfoMap = {
      "car_color": carColorTextEditingController.text.trim(),
      "car_number": carNumberTextEditingController.text.trim(),
      "car_model": carModelTextEditingController.text.trim(),
      "type": selectedCarType,
    };

    DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
    driversRef.child(currentFirebaseUser!.uid).child("car_details").set(driverCarInfoMap);

    Fluttertoast.showToast(msg: "Car details has been saved, Congratulations!");

    Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));

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
                "Fill Car Information",
                style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
              ),

              const SizedBox(height: 20,),

              //Car Model Field
              TextField(
                controller: carModelTextEditingController,
                style: const TextStyle(
                  color: Color(0xFFB0BEC5),
                ),
                decoration: const InputDecoration(
                  labelText: "Car Model",
                  hintText: "Car Model",
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

              //car number Field
              TextField(
                controller: carNumberTextEditingController,
                style: const TextStyle(
                  color: Color(0xFFB0BEC5),
                ),
                decoration: const InputDecoration(
                  labelText: "Car Number",
                  hintText: "Car Number",
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

              //Car Color Field
              TextField(
                controller: carColorTextEditingController,
                style: const TextStyle(
                  color: Color(0xFFB0BEC5),
                ),
                decoration: const InputDecoration(
                  labelText: "Car Color",
                  hintText: "Car Color",
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

              // Please select Car type
              DropdownButton(
                iconEnabledColor: Color(0xFFB0BEC5),
                iconSize: 20,
                dropdownColor: Color(0xFF413543),
                hint: const Text(
                  "Please choose type",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color(0xFFff725e),
                  ),
                ),
                value: selectedCarType,
                onChanged: (newValue){
                  setState(() {
                    selectedCarType = newValue.toString();
                  });
                },
                items: carTypeList.map((car){
                  return DropdownMenuItem(
                    child: Text(
                      car,
                      style: TextStyle(
                        color: const Color(0xFFB0BEC5)
                      ),
                    ),
                    value: car,
                  );
                }).toList(),
              ),

              const SizedBox(height: 30,),

              //Save Now button
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  onPressed: () {

                    if(carColorTextEditingController.text.isNotEmpty
                        && carNumberTextEditingController.text.isNotEmpty
                        &&  carModelTextEditingController.text.isNotEmpty
                        && selectedCarType != null){
                      saveCarInfo();
                    }

                    //Navigator.push(context, MaterialPageRoute(builder: (c)=> CarInfoScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFff725e),
                  ),
                  child: const Text(
                    "Save Now",
                    style: TextStyle(
                      color: Color(0xFF1a2e35),
                      fontSize: 18,
                    ),
                  ),

                ),
              )
              
            ],
          ),
        ),
      ),
    );
  }
}
