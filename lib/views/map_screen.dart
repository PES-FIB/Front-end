import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import 'package:prova_login/controllers/map_controller.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {

  final _controller = MapController();

  final _initialCameraPosition = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 12,
  );

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _controller.onMapCreated,
        initialCameraPosition: _initialCameraPosition,
        zoomControlsEnabled: false,
      ),
    );
  }


}