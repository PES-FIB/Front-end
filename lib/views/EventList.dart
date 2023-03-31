import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'event_screen.dart';
import '../controllers/eventsController.dart';

class Event {
  String code, title, description, imageLink, url, initialDate, finalDate, schedule, city, adress, tickets; // startDate, endDate, tickets, link, adress, location, placeOnLocation, email;
  Event(this.code, this.title, this.description, this.imageLink, this.url, this.initialDate, this.finalDate, this.schedule, this.city, this.adress, this.tickets); // this.startDate, this.endDate, this.tickets, this.link, this.adress, this.location, this.placeOnLocation, this.email);
  
}

class EventList extends StatefulWidget {
  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {

  List<Event> events = []; 
  Map<String,Event> saved = {};
  List<Event> _foundEvents = [];
  List<Event> result = [];


  Future<void> loadEvents() async {
    events = await EventsController.getAllEvents();
    saved = await EventsController.getSavedEvents();
  }

  

  void _runFilter(String enteredTitle) {
    if(enteredTitle.isEmpty) {
      result = events;
    } else {
      result = events.where((event) => event.title.toLowerCase().contains(enteredTitle.toLowerCase())).toList();
    }
    setState(() {_foundEvents = result; print(_foundEvents[3].title);});
  }

  void pushEventScreen(int clickedEvent) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => Events(event: events[clickedEvent])));
  }
  
  @override
  void initState() {
    loadEvents();
    //_foundEvents = events;
    super.initState();
  } 

  bool inSaved(String codeEvent){
    return saved.containsKey(codeEvent);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Column(
        children: [/*
          Padding( 
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                hintText: "busca un event" ,suffixIcon: Icon(Icons.search), contentPadding: EdgeInsets.all(20.0),
              ),
            ),
          ),*/
          Expanded(
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  key: ValueKey(events[index].title),
                  contentPadding: EdgeInsets.all(20.0),
                  title: Text(events[index].title),
                  //subtitle: Text(events[index].description),
                  leading:  Icon(Icons.event, color: Colors.black, size: 30),
                  trailing: IconButton(
                    iconSize: 25,
                    icon: Icon(Icons.favorite, color: inSaved(events[index].code)? Colors.redAccent: Color.fromARGB(255, 182, 179, 179)),
                    onPressed: () {
                    setState(() {
                      EventsController controller = EventsController(context);
                      if (inSaved(events[index].code)){
                        saved.remove(events[index].code);
                        controller.unsaveEvent(events[index].code);
                      }//remove
                      else {
                        saved[events[index].code] = events[index];
                        controller.saveEvent(events[index].code);
                      }//add
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