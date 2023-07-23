import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rideshare_driver/models/user_ride_request_information.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideshare_driver/assistants/black_theme_google_map.dart';
import 'package:rideshare_driver/global/global.dart';
import 'package:rideshare_driver/widgets/progress_dialog.dart';
import 'package:rideshare_driver/assistants/assistant_methods.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rideshare_driver/widgets/fare_amount_collection_dialog.dart';

class NewTripScreen extends StatefulWidget {

  UserRideRequestInformation? userRideRequestDetails;

  NewTripScreen({this.userRideRequestDetails});


  @override
  State<NewTripScreen> createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {

  GoogleMapController? newTripGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  String? buttonTitle = "Arrived";
  Color? buttonColor = Color(0xFFff725e);

  Set<Marker> setOfMarkers = Set<Marker>();
  Set<Circle> setOfCircles = Set<Circle>();
  Set<Polyline> setOfPolyline = Set<Polyline>();
  List<LatLng> polylinePositionCoordinated = [];
  PolylinePoints polylinePoints = PolylinePoints();

  double mapPadding = 0;

  BitmapDescriptor? iconAnimatedMarker;
  var geoLocator = Geolocator();
  Position? onlineDriverCurrentPosition;

  String rideRequestStatus = "accepted";
  String durationFromOriginToDestination = "";
  bool isRequestDirectionDetails = false;


  // Scenario 1. originLatLng = Driver Current Position, destinationLatLng = User Pickup Location
  // Scenario 2. originLatLng = User Pickup Location, destinationLatLng = dropoff location
  Future<void> drawPolylineFromOriginToDestination(LatLng originLatLng, LatLng destinationLatLng) async {

    showDialog(
      context: context,
      builder: (BuildContext context)=> ProgressDialog(message: "Please wait...",),
    );

    var directionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDetails(originLatLng, destinationLatLng);

    Navigator.pop(context);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyPointList = pPoints.decodePolyline(directionDetailsInfo!.e_points!);

    polylinePositionCoordinated.clear();

    if(decodedPolyPointList.isNotEmpty) {
      decodedPolyPointList.forEach((PointLatLng pointLatLng) {
        polylinePositionCoordinated.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    setOfPolyline.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: const Color(0xFFff725e),
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: polylinePositionCoordinated,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      setOfPolyline.add(polyline);
    });

    LatLngBounds boundsLatLng;
    if(originLatLng.latitude > destinationLatLng.latitude
        && originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    } else if(originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    } else if(originLatLng.latitude > destinationLatLng.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      boundsLatLng = LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }

    newTripGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    Marker originMarker = Marker(
      markerId: MarkerId("originID"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId("destinationID"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      setOfMarkers.add(originMarker);
      setOfMarkers.add(destinationMarker);
    });

    Circle originCircle = Circle(
      circleId: CircleId("originID"),
      fillColor: Colors.green,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: CircleId("destinationID"),
      fillColor: Colors.red,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatLng,
    );

    setState(() {
      setOfCircles.add(originCircle);
      setOfCircles.add(destinationCircle);
    });

  }

  @override
  void initState() {
    super.initState();

    saveAssignedDriverDetailsToUserRideRequest();
  }

  createDriverIconMarker() {
    if(iconAnimatedMarker == null) {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: const Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/carLogo.png").then((value){
        iconAnimatedMarker = value;
      });
    }
  }

  getDriversLocationUpdatesAtRealtime() {

    LatLng oldLatLng = LatLng(0, 0);

    streamSubscriptionDriverLivePosition = Geolocator.getPositionStream()
        .listen((Position position) {

      driverCurrentPosition = position;
      onlineDriverCurrentPosition = position;

      LatLng latLngLiveDriverPosition = LatLng(
        onlineDriverCurrentPosition!.latitude,
        onlineDriverCurrentPosition!.longitude,
      );

      Marker animatingMarker = Marker(
        markerId: const MarkerId("AnimatedMarker"),
        position: latLngLiveDriverPosition,
        icon: iconAnimatedMarker!,
        infoWindow: const InfoWindow(title: "This is your current position")
      );

      setState(() {
        CameraPosition cameraPosition = CameraPosition(
            target: latLngLiveDriverPosition,
            zoom: 16
        );
        newTripGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
        setOfMarkers.removeWhere((element) => element.markerId.value == "AnimatedMarker");
        setOfMarkers.add(animatingMarker);
      });

      oldLatLng = latLngLiveDriverPosition;
      updateDurationTimeAtRealTime();

      // Update driver location at real time in database
      Map driverLatLngDataMap = {
        "latitude": onlineDriverCurrentPosition!.latitude.toString(),
        "longitude": onlineDriverCurrentPosition!.longitude.toString(),
      };
      FirebaseDatabase.instance
          .ref()
          .child("All Ride Requests")
          .child(widget.userRideRequestDetails!.rideRequestId!)
          .child("driverLocation").set(driverLatLngDataMap);
    });
  }

  updateDurationTimeAtRealTime() async {

    if(isRequestDirectionDetails == false){

      isRequestDirectionDetails = true;

      if(onlineDriverCurrentPosition == null){
        return;
      }

      // Driver Current Position
      var originLatLng = LatLng(
        onlineDriverCurrentPosition!.latitude,
        onlineDriverCurrentPosition!.longitude,
      );

      var destinationLatLng;

      if(rideRequestStatus == "accepted") {
        // destination - user pickup location
        destinationLatLng = widget.userRideRequestDetails!.originLatlng;
      } else {
        // destination - user dropoff location
        destinationLatLng = widget.userRideRequestDetails!.destinationLatlng;
      }

      var directionInformation = await AssistantMethods.obtainOriginToDestinationDetails(originLatLng, destinationLatLng);

      if(directionInformation != null) {
        setState(() {
          durationFromOriginToDestination = directionInformation.durarion_text!;
        });
      }
      isRequestDirectionDetails = false;
    }
  }



  @override
  Widget build(BuildContext context) {

    createDriverIconMarker();

    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPadding),
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: _kGooglePlex,
            markers: setOfMarkers,
            circles: setOfCircles,
            polylines: setOfPolyline,
            onMapCreated: (GoogleMapController controller){
              _controllerGoogleMap.complete(controller);
              newTripGoogleMapController = controller;

              setState(() {
                mapPadding = 300;
              });

              //back Theme Google Map
              blackThemeGoogleMap(newTripGoogleMapController);

              var driverCurrentLatLng = LatLng(
                  driverCurrentPosition!.latitude, 
                  driverCurrentPosition!.longitude
              );
              
              var userPickupLatLng = widget.userRideRequestDetails!.originLatlng;

              drawPolylineFromOriginToDestination(driverCurrentLatLng!, userPickupLatLng!);

              getDriversLocationUpdatesAtRealtime();

            },
          ),

          //User Interface
          Positioned(
            bottom: 0,
            left: 10,
            right: 10,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF2D2727),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white30,
                    blurRadius: 18,
                    spreadRadius: 0.5,
                    offset: Offset(0.6, 0.6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  children: [

                    // Duration
                    Text(
                      durationFromOriginToDestination,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 15,),

                    const Divider(
                      thickness: 2,
                      height: 2,
                      color: Color(0xFFff725e),
                    ),

                    const SizedBox(height: 5,),

                    // Username and Icon
                    Row(
                      children: [
                        Text(
                          widget.userRideRequestDetails!.userName!,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFff725e),
                          ),
                        ),

                        const Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.phone_android,
                            color: Colors.white60,
                          ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 18,),

                    //User pickup location with icon
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

                    //User drop off location with icon
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

                    const SizedBox(height: 18.0,),

                    const Divider(
                      thickness: 2,
                      height: 2,
                      color: Color(0xFFff725e),
                    ),

                    const SizedBox(height: 10,),

                    ElevatedButton.icon( 
                      onPressed: () async {
                        // Driver has arrived at user pickup location
                        if(rideRequestStatus == "accepted"){
                          rideRequestStatus = "arrived";
                          FirebaseDatabase.instance
                              .ref()
                              .child("All Ride Requests")
                              .child(widget.userRideRequestDetails!.rideRequestId!)
                              .child("status").set(rideRequestStatus);

                          setState(() {
                            buttonTitle = "Let's Go"; // Start the trip
                            buttonColor = Color(0xFFff725e); // Color(0xFFff725e)
                          });
                          
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext c)=> ProgressDialog(
                                message: "Loading...",
                              ),
                          );

                          await drawPolylineFromOriginToDestination(
                              widget.userRideRequestDetails!.originLatlng!,
                              widget.userRideRequestDetails!.destinationLatlng!
                          );
                          Navigator.pop(context);

                        }

                        // Start the trip
                        else if(rideRequestStatus == "arrived"){
                          rideRequestStatus = "ontrip";
                          FirebaseDatabase.instance
                              .ref()
                              .child("All Ride Requests")
                              .child(widget.userRideRequestDetails!.rideRequestId!)
                              .child("status").set(rideRequestStatus);

                          setState(() {
                            buttonTitle = "End Trip"; // End the trip
                            buttonColor = Color(0xFFff725e); // Color(0xFFff725e)
                          });
                        }

                        // End the trip
                        else if(rideRequestStatus == "ontrip"){
                          endTripNow();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: buttonColor,
                      ),
                      icon: const Icon(
                        Icons.directions_car_filled,
                        color: Colors.white,
                        size: 25,
                      ),
                      label: Text(
                        buttonTitle!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  endTripNow() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext buildContext)=> ProgressDialog(
        message: "Loading...",
      ),
    );

    // get the trip direction details
    var currentDriverPositionLatLng = LatLng(
        onlineDriverCurrentPosition!.latitude,
        onlineDriverCurrentPosition!.longitude
    );

    var tripDirectionDetails = await  AssistantMethods.obtainOriginToDestinationDetails(
      currentDriverPositionLatLng,
      widget.userRideRequestDetails!.originLatlng!
    );

    // Fare Amount
    double totalFareAmount = AssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetails!);

    FirebaseDatabase.instance
        .ref()
        .child("All Ride Requests")
        .child(widget.userRideRequestDetails!.rideRequestId!)
        .child("fareAmount").set(totalFareAmount.toString());

    FirebaseDatabase.instance
        .ref()
        .child("All Ride Requests")
        .child(widget.userRideRequestDetails!.rideRequestId!)
        .child("status").set("ended");

    streamSubscriptionDriverLivePosition!.cancel();

    Navigator.pop(context);

    // Display Fare amount Dialog Box
    showDialog(
        context: context,
        builder: (BuildContext c)=> FareAmountCollectionDialog(
            totalFareAmount: totalFareAmount,
        ),
    );

    // save fare amount to driver total earnings
    saveFareAmountToDriverEarnings(totalFareAmount);

  }

  saveFareAmountToDriverEarnings(double totalFareAmount) {
    
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("earnings")
        .once()
        .then((snap) {
          // Earning sub child exists in database
          if(snap.snapshot.value != null) {
            double oldEarnings = double.parse(snap.snapshot.value.toString());
            double driverTotalEarnings = oldEarnings + totalFareAmount;
            FirebaseDatabase.instance
                .ref()
                .child("drivers")
                .child(currentFirebaseUser!.uid)
                .child("earnings")
                .set(driverTotalEarnings.toString());
          } else {
            FirebaseDatabase.instance
                .ref()
                .child("drivers")
                .child(currentFirebaseUser!.uid)
                .child("earnings")
                .set(totalFareAmount.toString());
          }
    });
    
  }

  saveAssignedDriverDetailsToUserRideRequest(){
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .ref()
        .child("All Ride Requests")
        .child(widget.userRideRequestDetails!.rideRequestId!);

    Map driverLocationDataMap = {
      "latitude":driverCurrentPosition!.latitude.toString(),
      "longitude":driverCurrentPosition!.longitude.toString()
    };
    databaseReference.child("driverLocation").set(driverLocationDataMap);

    databaseReference.child("status").set("accepted");
    databaseReference.child("driverId").set(onlineDriverData.id);
    databaseReference.child("driverName").set(onlineDriverData.name);
    databaseReference.child("driverPhone").set(onlineDriverData.phone);
    databaseReference.child("car_details").set(onlineDriverData.car_color.toString() + " " + onlineDriverData.car_model.toString() + " " + onlineDriverData.car_number.toString());

    //saveRideRequestIdToDriverHistory();
  }

/*  saveRideRequestIdToDriverHistory() {
    DatabaseReference tripsHistoryRef = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("tripsHistory");
    tripsHistoryRef.child(widget.userRideRequestDetails!.rideRequestId!).set(true);
  }*/

}
