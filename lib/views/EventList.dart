// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'event_screen.dart';
import '../controllers/events_controller.dart';

class Event {
  String title, description; // startDate, endDate, tickets, link, adress, location, placeOnLocation, email;
  bool fav;

  Event(this.title, this.description, this.fav); // this.startDate, this.endDate, this.tickets, this.link, this.adress, this.location, this.placeOnLocation, this.email);
  
}

class EventList extends StatefulWidget {
  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {

  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  Future<void> loadEvents() async {
    List<Event> loadedEvents = await EventsController.getAll();
    setState(() {
      events = loadedEvents;
      print('events loaded');
    });
  }

  void pushEventScreen(int clickedEvent) async {
    final updatedEvent = await Navigator.push(context, MaterialPageRoute(builder: (context) => Events(event: events[clickedEvent])));
    if (updatedEvent != null) {
      setState(() {
        events[clickedEvent] = updatedEvent;
      });
    }
  }
  
  /* 
  //FAKE EVENTS
  @override
  void initState() {
    events = [
      Event('Event 1', 'description of event 1', false),
      Event('Event 2', 'description of event 2', false),
      Event('Event 3', 'description of event 3', false),
    ];
    super.initState();
  } */


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: EdgeInsets.all(20.0),
          title: Text(events[index].title),
          subtitle: Text(events[index].description),
          leading:  Icon(Icons.event, color: Colors.black, size: 30),
          trailing: IconButton(
            iconSize: 25,
            icon: Icon(Icons.favorite, color: events[index].fav ? Colors.redAccent: Color.fromARGB(255, 182, 179, 179)),
            onPressed: () {
            setState(() {
              events[index].fav = !events[index].fav;
            });
            },
          ),

          onTap: () { 
            pushEventScreen(index);
          }
        );

      },
      itemCount: events.length,
    );
  }
}