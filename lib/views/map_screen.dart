import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prova_login/controllers/mapController.dart';
import 'dart:async';
import 'package:search_map_place_updated/search_map_place_updated.dart';
import '../models/AppEvents.dart';
import '../utils/gps.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => MapScreenState();
}


class MapScreenState extends State<MapScreen> {
  final GPS _gps = GPS();
  Position? _userPosition;
  Exception? _exception;

  //default camera position = barcelona.
  CameraPosition initialCameraPosition =  CameraPosition(
    target: LatLng(41.3926467,2.0701492),
    zoom: 12,
  );


  Set<Marker> _markers = {};
  String selectedAmbit = "Tots els events";
  List<String> ambits = [];

  Completer<GoogleMapController> _controllerCompleter = Completer();
  GoogleMapController? googleMapController;

  @override
  void initState() {
    super.initState();
    ambits.add("Tots els events");
    ambits.addAll(AppEvents.ambits);
    startChecking();
    _fetchMarkers();
    _gps.startPositionStream(_handlePositionStream).catchError((e) { setState(() {_exception = e;});});
  }

  void _handlePositionStream(Position position) async {
    googleMapController = await _controllerCompleter.future;
    setState(() {
      _userPosition = position;
      googleMapController?.animateCamera(CameraUpdate.newLatLng(LatLng(_userPosition!.latitude,_userPosition!.longitude)));
    });
  }

  void _fetchMarkers() {
    _markers.clear();
     setState(() {
      if (selectedAmbit == "Tots els events") {
        _markers = MapController.markers(context);
      } else {
        _markers = MapController.markersByAmbit(context, selectedAmbit);
      }
    });
  }

  void startChecking() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      MapController.checkSavedChanged(_fetchMarkers);
    });
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
            child: Stack(
              children: [
        
                GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _controllerCompleter.complete(controller);
                    MapController.onMapCreated(controller);
                  },
                  initialCameraPosition: initialCameraPosition,
                  zoomControlsEnabled: false,
                  markers: _markers,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                ),
                      
                Positioned(
                  top: 5.0,
                  left: 16.0,
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(width: 0.5, color: Colors.grey)
                    ),
                    child: DropdownButton(
                      value: selectedAmbit,
                      onChanged: (value) {
                        setState(() {
                          selectedAmbit = value as String;
                          _fetchMarkers();
                        });
                      },
                      items: ambits.map(
                        (e) {
                          return DropdownMenuItem(value: e, child: Text(e),);
                        }
                      ).toList(),
                    ),
                  )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
