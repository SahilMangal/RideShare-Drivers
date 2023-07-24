import 'package:firebase_auth/firebase_auth.dart';
import 'package:rideshare_driver/models/user_model.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:rideshare_driver/global/global.dart';
import 'package:rideshare_driver/models/driver_data.dart';
import 'dart:ui';
import 'package:flutter/material.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
StreamSubscription<Position>? streamSubscriptionPosition;
StreamSubscription<Position>? streamSubscriptionDriverLivePosition;
AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
Position? driverCurrentPosition;
DriverData onlineDriverData = DriverData();
String? driverVehicleType = "";
String titleStarsRating = "Good";
bool isDriverActive = false;
String statusText = "Now Offline";
Color buttonColor = Color(0xFFff725e);