import 'package:firebase_auth/firebase_auth.dart';
import 'package:rideshare_driver/models/user_model.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
StreamSubscription<Position>? streamSubscriptionPosition;
AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();