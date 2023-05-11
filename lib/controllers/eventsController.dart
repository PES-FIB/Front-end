import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import '../models/AppEvents.dart';
import '../models/Event.dart';
import 'dioController.dart';

class EventsController {
  final BuildContext context;
  EventsController(this.context);

  static Future<List<Event>> getAllEvents() async {
    List<Event> allEvents = []; //initialize empty event list.

    try {
      //request events
      final response =
          await dio.get('http://nattech.fib.upc.edu:40331/api/v1/events');

      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          for (int i = 0; i < response.data['data'].length; ++i) {
            //response is already decoded.

            //images can be empty
            String image;
            if (response.data['data'][i]['images'].isEmpty) {
              image = "";
            } else {
              image = response.data['data'][i]['images'][0];
            }

            //url can be null
            String url;
            if (response.data['data'][i]['url'] == null) {
              url = "";
            } else {
              url = response.data['data'][i]['url'];
            }

            String initD;
            if (response.data['data'][i]['initial_date'] == null) {
              initD = "";
            } else {
              initD = response.data['data'][i]['initial_date'];
            }

            String finalD;
            if (response.data['data'][i]['final_date'] == null) {
              finalD = "";
            } else {
              finalD = response.data['data'][i]['final_date'];
            }

            String schedule;
            if (response.data['data'][i]['schedule'] == null) {
              schedule = "";
            } else {
              schedule = response.data['data'][i]['schedule'];
            }

            String description;
            if (response.data['data'][i]['description'] == null) {
              description = "";
            } else {
              description = response.data['data'][i]['description'];
            }

            if (response.data['data'][i]['schedule'] == null) {
              schedule = "";
            } else {
              schedule = response.data['data'][i]['schedule'];
            }

            String city;
            if (response.data['data'][i]['region'] == null ||
                response.data['data'][i]['region'].length < 3) {
              city = "";
            } else {
              city = response.data['data'][i]['region'][2];
            }

            String adress;
            if (response.data['data'][i]['address'] == null) {
              adress = "";
            } else {
              adress = response.data['data'][i]['address'];
            }

            String tickets;
            if (response.data['data'][i]['tickets'] == null) {
              tickets = "";
            } else {
              tickets = response.data['data'][i]['tickets'];
            }

            Event event = Event(
              response.data['data'][i]['code'],
              response.data['data'][i]['denomination'],
              description,
              image,
              url,
              initD,
              finalD,
              schedule,
              city,
              adress,
              tickets,
            );
            allEvents.add(event);
          }
          print('he tornat events!!! num: ${allEvents.length}');
          return allEvents;
        }
      }
      print(' no he tornat events :((((');
      return []; // return an empty list if there was an error
    } catch (error) {
      print(error.toString());
      return []; // return an empty list if there was an error
    }
  }

  static Future<void> getSavedEvents() async {
    print('stacktrace de getEvents = ${StackTrace.current.toString()}');
    try {
      //request current user saved events
      final response = await dio
          .get('http://nattech.fib.upc.edu:40331/api/v1/users/savedEvents');

      //cheking events response
      print(response.statusCode);

      if (response.statusCode == 200) {
        if (response.data['events'] != null) {
          for (int i = 0; i < response.data['events'].length; ++i) {
            //response is already decoded.
            String image;
            if (response.data['events'][i]['images'].isEmpty) {
              image = "";
            } else {
              image = response.data['events'][i]['images'][0];
            }

            String url;
            if (response.data['events'][i]['url'] == null) {
              url = "";
            } else {
              url = response.data['events'][i]['url'];
            }

            String initD;
            if (response.data['events'][i]['initial_date'] == null) {
              initD = "";
            } else {
              initD = response.data['events'][i]['initial_date'];
            }

            String finalD;
            if (response.data['events'][i]['final_date'] == null) {
              finalD = "";
            } else {
              finalD = response.data['events'][i]['final_date'];
            }

            String schedule;
            if (response.data['events'][i]['schedule'] == null) {
              schedule = "";
            } else {
              schedule = response.data['events'][i]['schedule'];
            }

            String city;
            if (response.data['events'][i]['region'] == null ||
                response.data['events'][i]['region'].length < 3) {
              city = "";
            } else {
              city = response.data['events'][i]['region'][2];
            }

            String adress;
            if (response.data['events'][i]['adress'] == null) {
              adress = "";
            } else {
              adress = response.data['events'][i]['adress'];
            }

            String tickets;
            if (response.data['events'][i]['tickets'] == null) {
              tickets = "";
            } else {
              tickets = response.data['events'][i]['tickets'];
            }

            Event event = Event(
                response.data['events'][i]['code'],
                response.data['events'][i]['denomination'],
                response.data['events'][i]['description'],
                image,
                url,
                initD,
                finalD,
                schedule,
                city,
                adress,
                tickets);
            
            saveEventLocale(event);
          }
        }
      }
    } catch (error) {
      return; // return an empty list if there was an error
    }
  }

  static void saveEventLocale(Event e) {
    AppEvents.savedEvents[e.code] = e;
    if (AppEvents.savedEventsCalendar.containsKey(DateUtils.dateOnly(DateTime.parse(e.initialDate)))) {
      AppEvents.savedEventsCalendar[DateUtils.dateOnly(DateUtils.dateOnly(DateTime.parse(e.initialDate)))]?.add(e);
    } 
    else {
      List<Event> l = [e];
      AppEvents.savedEventsCalendar[DateUtils.dateOnly(DateUtils.dateOnly(
          DateTime.parse(e.initialDate)))] = l;
    }
  }

 static void unsaveEventLocale(Event e) {
  print("unsave event locale amb event ${e.title}");
  if (AppEvents.savedEvents.containsKey(e.code)) {
    AppEvents.savedEvents.remove(e.code);
  }
  final eventsOnDate = AppEvents.savedEventsCalendar[DateUtils.dateOnly(DateTime.parse(e.initialDate))];
  print('saved events calendar abans: ${eventsOnDate?.length}');
  if (eventsOnDate != null) {
    eventsOnDate.removeWhere((event) => event.code == e.code);
    print('saved events calendar despres: ${eventsOnDate.length}');
  }
}

  static void saveEvent(String codeEvent) async {
    try {
      //save event
      final response = await dio.post(
          'http://nattech.fib.upc.edu:40331/api/v1/users/saveEvent/$codeEvent');
      print("SAVED");
      //cheking response
      print(response.statusCode);
    } catch (error) {
      print(error.toString());
    }
  }

  static void unsaveEvent(String codeEvent) async {
    try {
      //unsave event
      final response = await dio.post(
          'http://nattech.fib.upc.edu:40331/api/v1/users/unsaveEvent/$codeEvent');
      print("UNSAVED");

      //cheking response
      print(response.statusCode);
    } catch (error) {
      print(error.toString());
    }
  }

  static Future<String> existsSavedEvent(String codeEvent) async {
    try {
      //auth login for getting autorization
      final authLogin = await dio.post(
          'http://nattech.fib.upc.edu:40331/api/v1/auth/login',
          data: {'email': 'cbum@gmail.com', 'password': 'cbumpostman'});
      //checking if event is saved
      final response = await dio.get(
          'http://nattech.fib.upc.edu:40331/api/v1/users/existSavedEvent/$codeEvent');

      print("statusCode existsSavedEvent:");
      print(response.statusCode);
      if (response.data['exists'] != null) {
        return response.data['exists'];
      } else {
        return "";
      }
    } catch (error) {
      print(error.toString());
      return "";
    }
  }
}
