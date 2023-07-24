import 'package:flutter/material.dart';
import 'package:rideshare_driver/mainScreens/trips_history_screen.dart';
import 'package:provider/provider.dart';
import 'package:rideshare_driver/infoHandler/app_info.dart';

class EarningsTabPage extends StatefulWidget {
  const EarningsTabPage({super.key});

  @override
  State<EarningsTabPage> createState() => _EarningsTabPageState();
}

class _EarningsTabPageState extends State<EarningsTabPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF2D2727),
      child: Column(
        children: [

          //Title and total earning
          Container(
            color: Color(0xFFff725e),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: Column(
                children: [
                  const Text(
                    "Total Earnings",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Ubuntu",
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                  const SizedBox(height: 10,),

                  Text(
                    "\$ " + Provider.of<AppInfo>(context, listen: false).driverTotalEarnings,
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "Ubuntu",
                        fontWeight: FontWeight.bold,
                        fontSize: 55
                    ),
                  ),
                ],
              ),
            ),
          ),

          //Total Number of trips
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.black87
            ),
            onPressed: (){

              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (c)=> TripsHistoryScreen())
              );

            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Row(
                children: [
                  Image.asset(
                    "images/car_logo.png",
                    width: 100,
                  ),

                  const SizedBox(width: 10 ,),

                  Text(
                    "Total Trips Completed",
                    style: TextStyle(
                      color: Color(0xFFff725e),
                      fontWeight: FontWeight.bold,
                      fontFamily: "Ubuntu",
                      fontSize: 16
                    ),
                  ),

                  Expanded(
                    child: Container(
                      child: Text(
                        "# " + Provider.of<AppInfo>(context, listen: false).allTripsHistoryInformationList.length.toString(),
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Ubuntu",
                          color: Color(0xFFff725e),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
