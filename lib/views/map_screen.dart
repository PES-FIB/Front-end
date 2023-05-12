import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prova_login/controllers/eventsController.dart';
import 'dart:async';
import 'package:search_map_place_updated/search_map_place_updated.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => MapScreenState();
}


class MapScreenState extends State<MapScreen> {
  Set<Marker> _markers = {};
  
  Completer<GoogleMapController> _controllerCompleter = Completer();
  GoogleMapController? googleMapController;

  @override
  void initState() {
    super.initState();
  }

  Future<Set<Marker>> _fetchMarkers() async {
    final markers = await EventsController.markers(context);
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
              iconColor: Colors.grey,
              clearIcon: Icons.clear,
              location: LatLng(41.3926467,2.0701492),
              radius: 3000,
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
                  return GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      _controllerCompleter.complete(controller);
                      EventsController.onMapCreated(controller);
                    },
                    initialCameraPosition: EventsController.initialCameraPosition,
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
