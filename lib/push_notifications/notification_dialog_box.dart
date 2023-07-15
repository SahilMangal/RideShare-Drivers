import 'package:flutter/material.dart';
import 'package:rideshare_driver/push_notifications/push_notification_system.dart';
import 'package:rideshare_driver/models/user_ride_request_information.dart';
import 'package:rideshare_driver/global/global.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class NotificationDialogBox extends StatefulWidget {

  UserRideRequestInformation? userRideRequestDetails;

  NotificationDialogBox({this.userRideRequestDetails});

  @override
  State<NotificationDialogBox> createState() => _NotificationDialogBoxState();
}

class _NotificationDialogBoxState extends State<NotificationDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.transparent,
      elevation: 2,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black54,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const SizedBox(height: 14.0,),

            Image.asset(
              "images/car_logo.png",
              width: 160,
            ),

            const SizedBox(height: 10,),

            // Title
            const Text(
              "New Ride Request",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Color(0xFFff725e)
              ),
            ),

            const SizedBox(height: 12.0,),

            const Divider(
              height: 3,
              thickness: 3,
            ),

            // Addresses origin and Destination
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Origin Location with Icon
                  Row(
                    children: [
                      Image.asset(
                        "images/origin.png",
                        width: 30,
                        height: 30,
                      ),

                      const SizedBox(width: 14,),

                      Expanded(
                        child: Container(
                          child: Text(
                            widget.userRideRequestDetails!.originAddress!,
                            style: const TextStyle(
                              fontSize: 16,
                                color: Color(0xFFff725e)
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20.0,),

                  // Destination Location with Icon
                  Row(
                    children: [
                      Image.asset(
                        "images/destination.png",
                        width: 30,
                        height: 30,
                      ),

                      const SizedBox(width: 14,),

                      Expanded(
                        child: Container(
                          child: Text(
                            widget.userRideRequestDetails!.destinationAddress!,
                            style: const TextStyle(
                              fontSize: 16,
                                color: Color(0xFFff725e)
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),

            const Divider(
              height: 3,
              thickness: 3,
            ),

            // Buttons Cancel and Accept
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Cancel Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFff725e),
                    ),
                    onPressed: (){
                      // Cancel the ride request

                      audioPlayer.pause();
                      audioPlayer.stop();
                      audioPlayer = AssetsAudioPlayer();

                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),

                  const SizedBox(width: 25.0,),

                  // Accept Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueGrey,
                    ),
                    onPressed: (){
                      // Accept the ride request

                      audioPlayer.pause();
                      audioPlayer.stop();
                      audioPlayer = AssetsAudioPlayer();

                      Navigator.pop(context);
                    },
                    child: Text(
                      "Accept".toUpperCase(),
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
