import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../utils/map_style.dart';
import '../models/Event.dart';
import '../controllers/eventsController.dart';
import '../views/event_screen.dart';

class MapController {

  final initialCameraPosition = const CameraPosition(
    target: LatLng(41.3926467,2.0701492),
    zoom: 12,
  );

  void onMapCreated(GoogleMapController controller){
    controller.setMapStyle(mapStyle);
  }

  Future<Set<Marker>> markers (BuildContext context) async {
    
    //get all events
    List<Event> allEvents = await EventsController.getAllEvents();


    Map<MarkerId, Marker> eventsMarkers = {};
    for(Event e in allEvents){

      if((e.latitude != "" ) && (e.longitude != "")) {
        final newMarkerId = MarkerId(e.code);
        final newMarker = Marker(
          markerId: newMarkerId,
          position: LatLng(double.parse(e.latitude), double.parse(e.longitude)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Events(event: e)),
            );
          }
        );
        eventsMarkers[newMarkerId] = newMarker;
      }
    }
    return eventsMarkers.values.toSet();
  }
}

