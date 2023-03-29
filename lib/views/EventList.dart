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

/*
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
  */
   
  //FAKE EVENTS
   List<Event>  events = [
      Event('Event 1', 'description of event 1', false),
      Event('Event 2', 'description of event 2', false),
      Event('Event 3', 'description of event 3', false),
  ];

  List<Event> _foundEvents = [];
  List<Event> result = [];

  @override
  void initState() {
    _foundEvents = events;
    super.initState();
  } 

  void _runFilter(String enteredTitle) {
    if(enteredTitle.isEmpty) {
      result = events;
    } else {
      result = events.where((Event) => Event.title.toLowerCase().contains(enteredTitle.toLowerCase())).toList();
    }
    setState(() {_foundEvents = result;});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Column(
        children: [
          TextField(
            onChanged: (value) => _runFilter(value),
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.search), contentPadding: EdgeInsets.all(20.0),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _foundEvents.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  key: ValueKey(_foundEvents[index].title),
                  contentPadding: EdgeInsets.all(20.0),
                  title: Text(_foundEvents[index].title),
                  subtitle: Text(_foundEvents[index].description),
                  leading:  Icon(Icons.event, color: Colors.black, size: 30),
                  trailing: IconButton(
                    iconSize: 25,
                    icon: Icon(Icons.favorite, color: _foundEvents[index].fav ? Colors.redAccent: Color.fromARGB(255, 182, 179, 179)),
                    onPressed: () {
                    setState(() {
                      _foundEvents[index].fav = !_foundEvents[index].fav;
                    });
                    },
                  ),
              
                  onTap: () { 
                    //pushEventScreen(index);
                  }
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}