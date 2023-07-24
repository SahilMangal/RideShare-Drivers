import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rideshare_driver/global/global.dart';
import 'package:rideshare_driver/widgets/info_design_ui.dart';
import 'package:rideshare_driver/splashScreen/splash_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileTabPage extends StatefulWidget {

  const ProfileTabPage({super.key});

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2727),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            //Name
            Text(
              onlineDriverData.name!,
              style: const TextStyle(
                fontSize: 50,
                fontFamily: "Ubuntu",
                fontWeight: FontWeight.bold,
                color: Color(0xFFff725e),
              ),
            ),

            Text(
              titleStarsRating + " Driver" + "!!",
              style: const TextStyle(
                fontSize: 18,
                fontFamily: "Ubuntu",
                fontWeight: FontWeight.bold,
                color: Colors.white54,
              ),
            ),

            const SizedBox(
              height: 20,
              width: 250,
              child: Divider(
                color: Color(0xFFff725e),
                height: 3,
                thickness: 3,
              ),
            ),

            const SizedBox(height: 38,),

            //Phone
            InfoDesignUIWidget(
              textInfo: onlineDriverData.phone!,
              iconData: Icons.phone_iphone,
            ),

            //Email
            InfoDesignUIWidget(
              textInfo: onlineDriverData.email!,
              iconData: Icons.email,
            ),

            InfoDesignUIWidget(
              textInfo: onlineDriverData.car_color! + " " + onlineDriverData.car_model! + " :: ( " + onlineDriverData.car_number! + " )",
              iconData: Icons.emoji_transportation,
            ),

            const SizedBox(height: 50,),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFff725e),
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 8,
                ),
              ),
              onPressed: (){

                // Logout User and display splash screen - Start
                Fluttertoast.showToast(msg: "Logout Successful...");
                fAuth.signOut();
                Navigator.push(
                    context, MaterialPageRoute(builder: (c)=> const MySplashScreen())
                );
                Future.delayed(Duration(seconds: 3), (){
                  SystemNavigator.pop();
                });
                // Logout User and display splash screen - End

              },
              child: const Text(
                "Logout",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Ubuntu"
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
