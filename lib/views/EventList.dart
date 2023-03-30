// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'event_screen.dart';
import '../controllers/eventsController.dart';

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

  Future<void> loadEvents() async {
    print('before calling');
    List<Event> loadedEvents = await EventsController.getAllEvents();
    print('after calling events controller');
    setState(() {
      events = loadedEvents;
      print('events loaded');
    });
  }

  void pushEventScreen(int clickedEvent) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => Events(event: events[clickedEvent])));
  }
  
  /* 
  //FAKE EVENTS
  var events = [
      Event('Event 1', 'description of event 1', false),
      Event('Event 2', 'description of event 2', false),
      Event('Event 3', 'description of event 3', false),
      Event('Event 4', 'description of event 1', false),
      Event('Event 5', 'description of event 2', false),
      Event('Event 6', 'description of event 3', false),
      Event('Event 7', 'description of event 1', false),
      Event('Cbum', 'description of event 2', false),
      Event('Marc', 'description of event 3', false),
      Event('Gerard', 'description of event 3', false),
  ];*/

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
      result = events.where((event) => event.title.toLowerCase().contains(enteredTitle.toLowerCase())).toList();
    }
    setState(() {_foundEvents = result;});
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                hintText: "busca un event" ,suffixIcon: Icon(Icons.search), contentPadding: EdgeInsets.all(20.0),
              ),
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
                      Event eventToUpdate = events.firstWhere((Event) => Event.title == _foundEvents[index].title);
                      eventToUpdate.fav = _foundEvents[index].fav;
                    });
                    },
                  ),
              
                  onTap: () { 
                    pushEventScreen(index);
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