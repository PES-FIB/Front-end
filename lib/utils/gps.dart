import 'dart:async';

import 'package:geolocator/geolocator.dart';

class GPS{

  late StreamSubscription<Position> _positionStream;

  Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(isAccesGranted(permission)){
      return true;
    }
    permission = await Geolocator.requestPermission();
    return isAccesGranted(permission);
  }

  bool isAccesGranted(LocationPermission permission) {
    return (permission == LocationPermission.whileInUse || permission ==LocationPermission.always);
  }

  Future<void> startPositionStream(Function(Position position) callback) async {
    bool permissionGranted = await requestPermission();
    if (!permissionGranted){
      throw Exception("User did not grant GPS permissions");
    }
    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.bestForNavigation)
    ).listen(callback);
  }

  Future<void> stopPositionStream() async {
    await _positionStream.cancel();
  }



}