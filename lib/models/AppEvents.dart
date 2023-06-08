import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'Event.dart';
import 'Task.dart';

final dio = Dio(
  BaseOptions(
    connectTimeout: Duration(seconds: 20),
    //los unicos status validos son 200 y 302
    validateStatus: (status) => status == 200 || status == 201 || status == 302 || status == 400 || status == 401 || status == 403 || status == 404 || status == 500,
  ),
);

class AppEvents {
  static Map<DateTime, List<Event>> savedEventsCalendar = {};
  static Map<String, Event> savedEvents = {};
  static List<Event> eventsList = [];
  static List<Event> mapEvents = []; //events showed in map(only futer events).
  static Map<DateTime, List<Task>> tasksCalendar = {};
  static List<String> ambits = [];
  static late bool savedChanged; 

}