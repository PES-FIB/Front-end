import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import 'package:prova_login/controllers/map_controller.dart';
import '../models/Event.dart';
import '../controllers/eventsController.dart';
import '../views/event_screen.dart';
import 'package:search_map_place_updated/search_map_place_updated.dart';
import '../utils/map_style.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => MapScreenState();
}


class MapScreenState extends State<MapScreen> {
  Set<Marker> _markers = {};
  final _controller = MapController();
  bool _markersFetched = false;
  
  Completer<GoogleMapController> _controllerCompleter = Completer();
  GoogleMapController? googleMapController;

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
      backgroundColor: Colors.white,
      body: Column(
        
        children: [
          SizedBox(height: 5),
          SearchMapPlaceWidget(
              apiKey: "AIzaSyAvlD4RSfucM-FOXtvvgys8V3dUVNTBqZI",
              bgColor: Colors.white,
              textColor: Colors.grey,
              iconColor: Colors.red,
              clearIcon: Icons.clear,
              onSelected: (Place place) async {
                final geolocation = await place.geolocation;

                // Will animate the GoogleMap camera, taking us to the selected position with an appropriate zoom
                googleMapController = await _controllerCompleter.future;
                googleMapController?.animateCamera(CameraUpdate.newLatLng(geolocation?.coordinates));
                googleMapController?.animateCamera(CameraUpdate.newLatLngBounds(geolocation?.bounds, 0));
            },
          ),
          SizedBox(height: 5),
          Expanded(
            child: FutureBuilder<Set<Marker>>(
              future: _fetchMarkers(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _markers = snapshot.data!;
                  _markersFetched = true;
                  return GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      _controllerCompleter.complete(controller);
                      _controller.onMapCreated(controller);
                    },
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
          ),
        ],
      ),
    );
  }

}
