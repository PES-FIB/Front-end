import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:prova_login/views/EventList.dart';
import 'map_screen.dart';
import 'favorites_screen.dart';
import 'perfil_screen.dart';
import '../models/Event.dart';
import '../controllers/eventsController.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var index = 0;
  var events = EventData();
  var fetchEvents = true;
  var fetchFavorites = true;

  @override
  void initState() {
    super.initState();
    fetchEvents = true;
    fetchFavorites = true;
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
      body: FutureBuilder(
        future: () async {
          if (index == 0 && fetchEvents) {
            await events.fetchData();
            fetchEvents = false;
          } else if (index == 2 && fetchFavorites) {
            await events.fetchData();
            fetchFavorites = false;
          }
        }(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While we're waiting for the data to be fetched, show a loading indicator
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there was an error fetching the data, show an error message
            return Center(child: Text('Error fetching data'));
          } else {
            // If we have the data, construct the pages
            final allEvents = events.allEvents;
            final savedEvents = events.savedEvents;
            final calendarEvents = events.calendarEvents;
            final pages = [
              EventList(
                events: allEvents,
                savedEvents: savedEvents,
              ),
              Map(),
              Favorites(
                savedEvents: calendarEvents,
              ),
              Perfil()
            ];
            return CupertinoTabScaffold(
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
                    if (ind == 0) {
                      fetchEvents = true;
                    } else if (ind == 2) {
                      fetchFavorites = true;
                    }
                  });
                },
              ),
              tabBuilder: (context, i) {
                return CupertinoTabView(
                  builder: (context) => pages[i],
                );
              },
            );
          }
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
