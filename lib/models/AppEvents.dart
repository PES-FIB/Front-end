import 'package:flutter/cupertino.dart';

import 'Event.dart';

class AppEvents {
  static ValueNotifier<Map<DateTime, List<Event>>> _savedEventsCalendar = ValueNotifier({});
  static ValueNotifier<Map<String, Event>> _savedEvents = ValueNotifier({});
  static ValueNotifier<List<Event>> _eventsList = ValueNotifier([]);

  static ValueNotifier<Map<DateTime, List<Event>>> get savedEventsCalendar {
    // create a new ValueNotifier instance that contains the entire map structure
    return ValueNotifier<Map<DateTime, List<Event>>>(_savedEventsCalendar.value);
  }

  static ValueNotifier<Map<String, Event>> get savedEvents {
    // create a new ValueNotifier instance that contains the entire map structure
    return ValueNotifier<Map<String, Event>>(_savedEvents.value);
  }

  static ValueNotifier<List<Event>> get eventsList {
    // create a new ValueNotifier instance that contains the entire list structure
    return ValueNotifier<List<Event>>(_eventsList.value);
  }

  static void updateSavedEventsCalendar(Map<DateTime, List<Event>> newValue) {
    // update the existing ValueNotifier instance with the new map
    _savedEventsCalendar.value = newValue;
  }

  static void updateSavedEvents(Map<String, Event> newValue) {
    // update the existing ValueNotifier instance with the new map
    _savedEvents.value = newValue;
  }

  static void updateEventsList(List<Event> newValue) {
    // update the existing ValueNotifier instance with the new list
    _eventsList.value = newValue;
  }
}