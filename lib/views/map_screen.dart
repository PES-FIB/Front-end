import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:prova_login/controllers/mapController.dart';
import 'dart:async';
import 'package:search_map_place_updated/search_map_place_updated.dart';
import '../controllers/eventsController.dart';
import '../models/AppEvents.dart';
import '../models/Event.dart';
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

  Completer<GoogleMapController> _controllerCompleter = Completer();
  GoogleMapController? googleMapController;

  Set<Marker> _markers = {};
  String selectedAmbit = "Tots els events";
  List<String> ambits = [];

  bool rangeSelected = false;
  DateTimeRange selectedDates = DateTimeRange(start: DateTime.now(), end: DateTime.now()); 
  String dataIni = "";
  String dataFi = "";
  List<Event> filteredEvents = List.from(AppEvents.mapEvents);

  //default camera position = barcelona.
  CameraPosition initialCameraPosition =  CameraPosition(
    target: LatLng(41.3926467,2.0701492),
    zoom: 12,
  );

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
        _markers = MapController.markers(context, filteredEvents);
      } else {
        _markers = MapController.markersByAmbit(context, selectedAmbit, filteredEvents);
      }
    });
  }

  void startChecking() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      MapController.checkSavedChanged(_fetchMarkers);
    });
  } 


  void filterByDateRange() async{
  
    //year-month-day
    List<String>  dirtyInitDate = selectedDates.start.toString().split(" ");
    //[year] [month] [day] 
    List<String> initDate = dirtyInitDate[0].split("-");
    //month/day/year
    String queryInitDate = initDate[1] + "/" + initDate[2] + "/" + initDate[0];
    print(queryInitDate);

    //year-month-day
    List<String>  dirtyFinalDate = selectedDates.end.toString().split(" ");
    //[year] [month] [day] 
    List<String> finalDate = dirtyFinalDate[0].split("-");
    //month/day/year
    String queryFinalDate = finalDate[1] + "/" + finalDate[2] + "/" + finalDate[0];
    print(queryFinalDate);

    dataIni = initDate[2] + "/" + initDate[1] + "/" + initDate[0]; 
    dataFi = finalDate[2] + "/" + finalDate[1] + "/" + finalDate[0]; 

    List<Event> result = await EventsController.getEventsByDateRange(queryInitDate, queryFinalDate);
    
    setState(() {
      filteredEvents = result;
      _fetchMarkers();
    });  
  }



  @override
  void initState() {
    super.initState();
    ambits.add("Tots els events");
    ambits.addAll(AppEvents.ambits);
    startChecking();
    _fetchMarkers();
    _gps.startPositionStream(_handlePositionStream).catchError((e) { setState(() {_exception = e;});});
    print("init state");
    print(AppEvents.mapEvents);
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
              placeholder: "Cerca un lloc",
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
                  child: Row(
                    children: [
                      Container(
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
                      ), 
                      SizedBox(width: 10),
                      Container(
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(width: 0.5, color: Colors.grey)
                        ),
                        child: IconButton(
                          iconSize: 27,
                          icon: Icon(LineAwesomeIcons.alternate_calendar),
                          onPressed: () async {
                            final DateTimeRange? dateTimeRange = await showDateRangePicker(
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: Colors.redAccent, 
                                      onPrimary: Colors.white, 
                                      onSurface: Colors.grey, 
                                    ),
                                   ),
                                  child: child!,
                                );
                              },
                              context: context, 
                              firstDate: DateTime.now(), 
                              lastDate: DateTime(3000),
                              //initialDateRange: selectedDates,
                            );
                            if(dateTimeRange != null) {
                              setState(() {
                                selectedDates = dateTimeRange;
                                filterByDateRange();
                                rangeSelected = true;
                              });
                            }
                          },
                         ),
                        ),
                        SizedBox(width: 3),
                        Container(
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(width: 0.5, color: Colors.grey)
                          ),
                          child: IconButton(
                            iconSize: 25,
                            icon: Icon(LineAwesomeIcons.calendar_times),
                            onPressed: () {
                              setState(() {
                                filteredEvents = List.from(AppEvents.mapEvents);
                                rangeSelected = false;
                              });
                              _fetchMarkers();
                              print(AppEvents.mapEvents.length);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                Visibility(
                  visible: rangeSelected,
                  child: Positioned(
                    top: 60.0,
                    left: 16,
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 240, 162, 162),
                      ),
                      child: Text("Events del " + dataIni + " a " + dataFi)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
