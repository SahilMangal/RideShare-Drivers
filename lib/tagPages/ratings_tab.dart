import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rideshare_driver/global/global.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:provider/provider.dart';
import 'package:rideshare_driver/infoHandler/app_info.dart';

class RatingsTagPage extends StatefulWidget {

  const RatingsTagPage({super.key});

  @override
  State<RatingsTagPage> createState() => _RatingsTagPageState();
}

class _RatingsTagPageState extends State<RatingsTagPage> {

  double ratingsNumber = 0;

  @override
  void initState() {
    super.initState();

    getRatingsNumber();
  }

  getRatingsNumber() {
    setState(() {
      ratingsNumber = double.parse(Provider.of<AppInfo>(context, listen: false).driverAverageRatings);
    });
    setUpRatingTitle();
  }

  setUpRatingTitle() {
    if(ratingsNumber == 1){
      setState(() {
        titleStarsRating = "Very Bad";
      });
    }

    if(ratingsNumber == 2){
      setState(() {
        titleStarsRating = "Bad";
      });
    }

    if(ratingsNumber == 3){
      setState(() {
        titleStarsRating = "Good";
      });
    }

    if(ratingsNumber == 4){
      setState(() {
        titleStarsRating = "Very Good";
      });
    }

    if(ratingsNumber == 5){
      setState(() {
        titleStarsRating = "Excellent";
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xFF2D2727),
            border: Border.all(color: Color(0xFFff725e), width: 3),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFff725e),
                blurRadius: 4,
                offset: Offset(2, 2), // Shadow position
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const SizedBox(height: 20,),

              const Text(
                "Average Rating",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 3,
                    color: Color(0xFFff725e),
                    fontFamily: "PTSerif"
                ),
              ),

              const SizedBox(height: 20,),

              const Divider(
                height: 3,
                thickness: 3,
                color: Color(0xFFff725e),
              ),

              const SizedBox(height: 20,),

              SmoothStarRating(
                rating: ratingsNumber,
                allowHalfRating: false,
                starCount: 5,
                size: 46,
                color: const Color(0xFFff725e),
                borderColor: Colors.white30,
              ),

              const SizedBox(height: 15,),

              Text(
                titleStarsRating,
                style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontFamily: "PTSerif"
                ),
              ),

              const SizedBox(height: 18,),


            ],
          ),
        ),
      ),
    );
  }
}
