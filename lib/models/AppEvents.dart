

import 'Event.dart';
import 'Task.dart';

class AppEvents {
  static Map<DateTime, List<Event>> savedEventsCalendar = {};
  static Map<String, Event> savedEvents = {};
  static List<Event> eventsList = [];
  static Map<DateTime, List<Task>> tasksCalendar = {};
}