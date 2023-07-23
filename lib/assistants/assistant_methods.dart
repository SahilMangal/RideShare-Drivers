import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rideshare_driver/assistants/request_assistant.dart';
import 'package:rideshare_driver/models/directions.dart';
import 'package:rideshare_driver/infoHandler/app_info.dart';
import 'package:rideshare_driver/global/global.dart';
import 'package:rideshare_driver/models/user_model.dart';
import 'package:rideshare_driver/models/direction_details_info.dart';
import 'package:rideshare_driver/global/map_key.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:rideshare_driver/models/trips_history_model.dart';

class AssistantMethods{

  static Future<String> searchAddressForGeographicCoordinated(Position position, context) async {

    String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    String humanReadableAddress="";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);
    if(requestResponse != "Error Occurred, No Response."){
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickupAddress = Directions();
      userPickupAddress.locationLatitude = position.latitude;
      userPickupAddress.locationLongitude = position.longitude;
      userPickupAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false).updatePickupLocationAddress(userPickupAddress);


    }
    return humanReadableAddress;
  }

  static Future<DirectionDetailsInfo?> obtainOriginToDestinationDetails(LatLng originPosition, LatLng destinationPosition) async {
    String urlObtainOriginToDestinationDetails = "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey";

    var responseDirectionsApi =  await RequestAssistant.receiveRequest(urlObtainOriginToDestinationDetails);

    if (responseDirectionsApi == "Error Occurred, No Response.") {
      return null;
    }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.e_points = responseDirectionsApi["routes"][0]["overview_polyline"]["points"];

    directionDetailsInfo.distance_text = responseDirectionsApi["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distance_value = responseDirectionsApi["routes"][0]["legs"][0]["distance"]["value"];

    directionDetailsInfo.durarion_text = responseDirectionsApi["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.duration_value = responseDirectionsApi["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetailsInfo;
  }

  static pauseLiveLocationUpdated() {
    streamSubscriptionPosition!.pause();
    Geofire.removeLocation(currentFirebaseUser!.uid);
  }

  static resumeLiveLocationUpdated() {
    streamSubscriptionPosition!.resume();
    Geofire.setLocation(currentFirebaseUser!.uid,
        driverCurrentPosition!.latitude,
        driverCurrentPosition!.longitude
    );
  }

  static double calculateFareAmountFromOriginToDestination(DirectionDetailsInfo directionDetailsInfo) {
    double timeTravelFareAmountPerMinute = (directionDetailsInfo.duration_value! / 60) * 0.9;
    double distanceTraveledFareAmountPerKilometer = (directionDetailsInfo.distance_value! / 1000) * 0.9;

    double totalFareAmount = timeTravelFareAmountPerMinute + distanceTraveledFareAmountPerKilometer;

    if(driverVehicleType == "bike"){
      double resultFareAmount = (totalFareAmount.truncate()) / 2.0;
      return resultFareAmount;
    } else if (driverVehicleType == "Car"){
      return totalFareAmount.truncate().toDouble();
    } else if (driverVehicleType == "Car-XL"){
      double resultFareAmount = (totalFareAmount.truncate()) * 2.0;
      return resultFareAmount;
    } else {
      return totalFareAmount.truncate().toDouble();
    }
  }

  // Retrieve the trip keys for online user
  static void readTripsKeysForOnlineDriver(context){
    FirebaseDatabase.instance
        .ref()
        .child("All Ride Requests")
        .orderByChild("driverId")
        .equalTo(fAuth.currentUser!.uid)
        .once().then((snap) {
      if(snap.snapshot.value != null) {
        Map keysTripsId = snap.snapshot.value as Map;
        int overAllTripsCounter = keysTripsId.length;
        Provider.of<AppInfo>(context, listen: false).updateOverAllTripsCounter(overAllTripsCounter);

        List<String> tripsKeysList = [];
        keysTripsId.forEach((key, value) {
          tripsKeysList.add(key);
        });
        Provider.of<AppInfo>(context, listen: false).updateOverAllTripsKeys(tripsKeysList);

        // Trip Complete Info
        readTripsHistoryInformation(context);

      }
    });
  }

  static void readTripsHistoryInformation(context) {

    var tripsAllKeys = Provider.of<AppInfo>(context, listen: false).historyTripsKeysList;

    for(String eachKey in tripsAllKeys)
    {
      FirebaseDatabase.instance.ref()
          .child("All Ride Requests")
          .child(eachKey)
          .once()
          .then((snap)
      {
        var eachTripHistory = TripsHistoryModel.fromSnapshot(snap.snapshot);

        if((snap.snapshot.value as Map)["status"] == "ended") {
          Provider.of<AppInfo>(context, listen: false).updateOverAllTripHistoryInformation(eachTripHistory);
        }
      });
    }
  }

  // Read Driver Earnings
  static void readDriverEarnings(context) {
    
    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(fAuth.currentUser!.uid)
        .child("earnings")
        .once()
        .then((snap) {
       if(snap.snapshot.value != null) {
         String driverEarnings = snap.snapshot.value.toString();
         Provider.of<AppInfo>(context, listen: false).updateDriverTotalEarnings(driverEarnings);
       }
    });

    readTripsKeysForOnlineDriver(context);
    
  }
}