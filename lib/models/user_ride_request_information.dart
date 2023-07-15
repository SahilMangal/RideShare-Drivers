import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserRideRequestInformation{

  LatLng? originLatlng;
  LatLng? destinationLatlng;
  String? originAddress;
  String? destinationAddress;
  String? rideRequestId;
  String? userName;
  String? userPhone;

  UserRideRequestInformation({
    this.userName,
    this.userPhone,
    this.rideRequestId,
    this.originLatlng,
    this.originAddress,
    this.destinationLatlng,
    this.destinationAddress
  });

}