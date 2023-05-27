

import 'package:dio/dio.dart';
import 'Event.dart';
import 'Task.dart';

final dio = Dio(
  BaseOptions(
    connectTimeout: Duration(seconds: 20),
    //los unicos status validos son 200 y 302
    validateStatus: (status) => status == 200 || status == 201 || status == 302,
  ),
);

class AppEvents {
  static Map<DateTime, List<Event>> savedEventsCalendar = {};
  static Map<String, Event> savedEvents = {};
  static List<Event> eventsList = [];
  static Map<DateTime, List<Task>> tasksCalendar = {};
  static List<String> ambits = [];
}