// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'event_screen.dart';

class Event {
  String title, description; // startDate, endDate, tickets, link, adress, location, placeOnLocation, email;
  Event(this.title, this.description); // this.startDate, this.endDate, this.tickets, this.link, this.adress, this.location, this.placeOnLocation, this.email);
}

class EventList extends StatefulWidget {
  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {

  List events = [];

  
  @override
  void initState() {
    events = [
      Event('Event 1', 'description of event 1'),
      Event('Event 2', 'description of event 2'),
      Event('Event 3', 'description of event 3'),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        
        return ListTile(
          title: Text(events[index].title),
          subtitle: Text(events[index].description),
          leading:  Icon(Icons.calendar_month),
          trailing: Icon(Icons.favorite_border),

          onTap: () { 
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Events()));
          }
        );

      },
      itemCount: events.length,
    );
  }
}