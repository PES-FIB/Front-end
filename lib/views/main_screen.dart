import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:prova_login/views/EventList.dart';
import 'map_screen.dart';
import 'favorites_screen.dart';
import 'perfil_screen.dart';
import '../models/Event.dart';
import '../controllers/eventsController.dart';
import '../models/AppEvents.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var index = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.redAccent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "C U L T U R I C A 'T",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(LineAwesomeIcons.calendar),
                label: 'events',
              ),
              BottomNavigationBarItem(
                icon: Icon(LineAwesomeIcons.map_marker),
                label: 'map',
              ),
              BottomNavigationBarItem(
                icon: Icon(LineAwesomeIcons.heart),
                label: 'favs',
              ),
              BottomNavigationBarItem(
                icon: Icon(LineAwesomeIcons.user),
                label: 'perfil',
              ),
            ],
            activeColor: Colors.redAccent,
            currentIndex: index,
            onTap: (ind) {
              setState(() {
                index = ind;
              });
            }),
        tabBuilder: (context, i) {
          return CupertinoTabView(
            builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                if (i == 0) {
                  return EventList();
                } 
                else if(i == 1) {
                  return Map();
                }
                else if(i == 2) {
                  return Favorites();
                }
                else {
                  return Perfil();
                }
              });
          });
        },
      ),
    );
  }
}

class EventData {
  List<Event> allEvents = [];
  var savedEvents = {};
  var calendarEvents = {};

  Future<void> fetchData() async {
    allEvents = await EventsController.getAllEvents();
    savedEvents = await EventsController.getSavedEvents();
    calendarEvents = await EventsController.getSavedEventsCalendar();
  }
}
