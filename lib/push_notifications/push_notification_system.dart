import 'package:rideshare_driver/global/global.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';

class PushNotificationSystem {

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializeCloudMessaging() async {

    // 1. Terminated - When the app is completely closed
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? remoteMessage) {
      if(remoteMessage != null) {
        // Display ride request information - user information
      }
    });

    // 2. Foreground - When the app is open / using the app
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      // Display ride request information - user information
    });

    // 3. Background - When the app is running in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      // Display ride request information - user information
    });

  }

  Future generateAndGetToken() async {

    String? registrationToken = await messaging.getToken();
    
    print("******* Registration Token: ");
    print(registrationToken);
    
    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("token")
        .set(registrationToken);
    
    messaging.subscribeToTopic("allDrivers");
    messaging.subscribeToTopic("allUsers");

  }


}