import 'package:flutter/cupertino.dart';

import 'Event.dart';

class AppEvents {

  static ValueNotifier<Map<DateTime, List<Event>>> savedEventsCalendar = ValueNotifier({});
  static ValueNotifier<Map<String, Event>> savedEvents = ValueNotifier({});
  static ValueNotifier<List<Event>> eventsList = ValueNotifier([]);

}