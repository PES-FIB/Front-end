import 'package:flutter/material.dart';
import 'dart:async';
import '../models/Event.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../utils/map_style.dart';
import '../views/event_screen.dart';
import 'eventsController.dart';

class mapController {


  static const initialCameraPosition =  CameraPosition(
    target: LatLng(41.3926467,2.0701492),
    zoom: 12,
  );

  static void onMapCreated(GoogleMapController controller){
    controller.setMapStyle(mapStyle);
  }

  static Future<Set<Marker>> markers (BuildContext context) async {
    
    //get all events
    List<Event> allEvents = await EventsController.getAllEvents();


    Map<MarkerId, Marker> eventsMarkers = {};
    for(Event e in allEvents){

      if((e.latitude != "" ) && (e.longitude != "")) {
        final newMarkerId = MarkerId(e.code);
        final newMarker = Marker(
          markerId: newMarkerId,
          position: LatLng(double.parse(e.latitude), double.parse(e.longitude)),
          onTap: () async {
            await showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: Events(event: e),
                );
              },
            );
          }
        );
        eventsMarkers[newMarkerId] = newMarker;
      }
    }
    return eventsMarkers.values.toSet();
  }
}