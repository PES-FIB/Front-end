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
  
  /*
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
          
          title: Text(events[index].title),
          subtitle: Text(events[index].description),
          leading:  Icon(Icons.calendar_month, color: Colors.black, size: 30,),
          trailing: IconButton(
            color: Colors.black,
            iconSize: 20,
            icon: Icon(Icons.favorite, color: events[index].fav ? Colors.redAccent: Colors.black),
            onPressed: () {
            setState(() {
              events[index].fav = !events[index].fav;
            });
            },
          ),

          onTap: () { 
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Events()));
          }
        );

      },
      itemCount: events.length,
    );
  }
}