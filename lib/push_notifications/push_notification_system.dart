import 'package:flutter/material.dart';
import 'package:rideshare_driver/global/global.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rideshare_driver/models/user_ride_request_information.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'notification_dialog_box.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class PushNotificationSystem {

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializeCloudMessaging(BuildContext context) async {

    // 1. Terminated - When the app is completely closed
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? remoteMessage) {
      if(remoteMessage != null) {
        // Display ride request information - user information
        readUserRideRequestInformation(remoteMessage!.data["rideRequestId"], context);
      } else {
        print("*********** remoteMessage is null ***********");
      }
    });

    // 2. Foreground - When the app is open / using the app
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      // Display ride request information - user information
      readUserRideRequestInformation(remoteMessage!.data["rideRequestId"], context);
    });

    // 3. Background - When the app is running in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      // Display ride request information - user information
      readUserRideRequestInformation(remoteMessage!.data["rideRequestId"], context);
    });

  }

  readUserRideRequestInformation(String userRideRequestId, BuildContext context) {
    FirebaseDatabase.instance.ref()
        .child("All Ride Requests")
        .child(userRideRequestId).once().then((snapData){
          if(snapData.snapshot.value != null){

            audioPlayer.open(Audio("music/music_notification.mp3"));
            audioPlayer.play();

            double originLat = double.parse((snapData.snapshot.value! as Map)["origin"]["latitude"]);
            double originLng = double.parse((snapData.snapshot.value! as Map)["origin"]["longitude"]);
            String originAddress = (snapData.snapshot.value! as Map)["originAddress"];

            double destinationLat = double.parse((snapData.snapshot.value! as Map)["destination"]["latitude"]);
            double destinationLng = double.parse((snapData.snapshot.value! as Map)["destination"]["longitude"]);
            String destinationAddress = (snapData.snapshot.value! as Map)["destinationAddress"];

            String userName = (snapData.snapshot.value! as Map)["userName"];
            String userPhone = (snapData.snapshot.value! as Map)["userPhone"];

            UserRideRequestInformation userRideRequestDetails = UserRideRequestInformation();
            userRideRequestDetails.originLatlng = LatLng(originLat, originLng);
            userRideRequestDetails.originAddress = originAddress;

            userRideRequestDetails.destinationLatlng = LatLng(destinationLat, destinationLng);
            userRideRequestDetails.destinationAddress = destinationAddress;

            userRideRequestDetails.userName = userName;
            userRideRequestDetails.userPhone = userPhone;
            
            print("************ This is user ride request information ************");
            print(userRideRequestDetails.userName);

            showDialog(
                context: context,
                builder: (BuildContext context) => NotificationDialogBox(
                    userRideRequestDetails: userRideRequestDetails,
                ),
            );

          } else {
            print("*********** remoteMessage is null ***********");
            Fluttertoast.showToast(msg: "This ride request ID don't exist.");
          }
    });

  }

  Future generateAndGetToken() async {

    String? registrationToken = await messaging.getToken(); // Generate and get token
    
    print("******* Registration Token Starts *******");
    print(registrationToken);
    print("******* Registration Token Ends *******");
    
    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("token")
        .set(registrationToken);
    
    messaging.subscribeToTopic("allDrivers");
    messaging.subscribeToTopic("allUsers");

  }


}