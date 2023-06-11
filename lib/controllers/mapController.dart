import 'package:flutter/material.dart';
import '../models/Event.dart';
import '../models/AppEvents.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../utils/map_style.dart';
import '../views/event_screen.dart';

class MapController {

  static void onMapCreated(GoogleMapController controller){
    controller.setMapStyle(mapStyle);
  }

  static Set<Marker> markers (BuildContext context, List<Event> filteredEvents) {

    Map<MarkerId, Marker> eventsMarkers = {};

    for(Event e in filteredEvents){
      if((e.latitude != "" ) && (e.longitude != "")) {
        final newMarkerId = MarkerId(e.code);
        //if saved --> yellow
        if(AppEvents.savedEvents.containsKey(e.code)) {
          final newMarker = Marker(
            markerId: newMarkerId,
            position: LatLng(double.parse(e.latitude), double.parse(e.longitude)),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
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
        //not saved --> default red
        else {
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
    }
    return eventsMarkers.values.toSet();
  }


  static Set<Marker> markersByAmbit (BuildContext context, String ambit, List<Event> filteredEvents) {    
   
    Map<MarkerId, Marker> eventsMarkers = {};

    for(Event e in filteredEvents){ 
      if(e.ambits.contains(ambit)) {
        if((e.latitude != "" ) && (e.longitude != "")) {
          final newMarkerId = MarkerId(e.code);
          //if saved --> yellow
          if(AppEvents.savedEvents.containsKey(e.code)) {
            final newMarker = Marker(
              markerId: newMarkerId,
              position: LatLng(double.parse(e.latitude), double.parse(e.longitude)),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
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
          //not saved --> default red
          else {
            final newMarker = Marker(
              markerId: newMarkerId,
              position: LatLng(double.parse(e.latitude), double.parse(e.longitude)),
              icon: BitmapDescriptor.defaultMarker,
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
      }
    }
    return eventsMarkers.values.toSet();
  }

  static void checkSavedChanged(Function callback) {
    if (AppEvents.savedChanged) {
      AppEvents.savedChanged = false;
      callback();
    } 
  }
}