// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class Event {
  String title, description;
  Event(this.title, this.description);
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
        );

      },
      itemCount: events.length,
    );
  }
}