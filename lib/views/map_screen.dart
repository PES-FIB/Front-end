import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import 'package:prova_login/controllers/map_controller.dart';
import '../models/Event.dart';
import '../controllers/eventsController.dart';
import '../views/event_screen.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => MapScreenState();
}


class MapScreenState extends State<MapScreen> {
  Set<Marker> _markers = {};
  final _controller = MapController();
  bool _markersFetched = false;


  @override
  void initState() {
    super.initState();
  }

  Future<Set<Marker>> _fetchMarkers() async {
    final markers = await _controller.markers(context);
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:     
        FutureBuilder<Set<Marker>>(
              future: _fetchMarkers(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _markers = snapshot.data!;
                  _markersFetched = true;
                  return GoogleMap(
                    onMapCreated: _controller.onMapCreated,
                    initialCameraPosition: _controller.initialCameraPosition,
                    zoomControlsEnabled: false,
                    markers: _markers,
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error fetching markers"));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
          ),
      );
  }
}
