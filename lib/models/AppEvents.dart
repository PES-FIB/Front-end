import 'package:flutter/cupertino.dart';

import 'Event.dart';

class AppEvents {
  static Map<DateTime, List<Event>> savedEventsCalendar = {};
  static Map<String, Event> savedEvents = {};
  static List<Event> eventsList = [];
}