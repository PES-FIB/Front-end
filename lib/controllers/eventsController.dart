import 'package:flutter/material.dart';
import 'package:http/http.dart';

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
        if(response.data['data'] != null) {
          for (int i = 0; i < response.data['data'].length; ++i) { //response is already decoded. 
        
          String code;
          if (response.data['data'][i]['code']== null) {
            code = "";
          } else {
            code = response.data['data'][i]['code'];
          }

          String denomination;
          if (response.data['data'][i]['denomination']== null) {
            denomination = "";
          } else {
            denomination = response.data['data'][i]['denomination'];
          }

          String description;
          if (response.data['data'][i]['description']== null) {
            description = "";
          } else {
            description = response.data['data'][i]['description'];
          }

          String image;
          if (response.data['data'][i]['images'].isEmpty) {
            image = "";
          } else {
            image = response.data['data'][i]['images'][0];
          }

          String url;
          if (response.data['data'][i]['url'] == null) {
            url = "";
          } else { url = response.data['data'][i]['url']; }

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

          String city;
          if (response.data['data'][i]['region'] == null || response.data['data'][i]['region'].length < 3) {
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

          List<dynamic> ambits = [];
          if(response.data['data'][i]['ambits'] != null) ambits.addAll(response.data['data'][i]['ambits']);

          Event event = Event(
            response.data['data'][i]['code'],

          String latitude;
          if (response.data['data'][i]['latitude'] == null) {
            latitude = "";
          } else {
            latitude = response.data['data'][i]['latitude'];
          }

          String longitude;
          if (response.data['data'][i]['longitude'] == null) {
            longitude = "";
          } else {
            longitude = response.data['data'][i]['longitude'];
          }

          Event event = Event(
            code,
            denomination,
            description,
            image,
            url,
            initD,
            finalD,
            schedule,
            city,
            adress,
            tickets,
            latitude,
            longitude,
            ambits,
          );
          allEvents.add(event);
          }
          
          return allEvents;
        }
      }
      print(' no he tornat events :((((');
      return []; // return an empty list if there was an error
    } catch (error) {
      print("Error: $error");
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

            String latitude;
          if (response.data['data'][i]['latitude'] == null) {
            latitude = "";
          } else {
            latitude = response.data['data'][i]['latitude'];
          }

          String longitude;
          if (response.data['data'][i]['longitude'] == null) {
            longitude = "";
          } else {
            longitude = response.data['data'][i]['longitude'];
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
                tickets,
                latitude,
                longitude,
                ambits,);
            
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

static Future<Event> getEventByCode(String code) async {
    Event emptyEvent = Event("", "", "", "", "", "", "", "", "", "", "", "", "");
    try {
      //auth login for getting autorization
      final authLogin = await dio.post('http://nattech.fib.upc.edu:40331/api/v1/auth/login', data: {'email':'cbum@gmail.com', 'password':'cbumpostman'});
      //checking if event is saved
      final response = await dio.get('http://nattech.fib.upc.edu:40331/api/v1/events/$code');
      if(response.statusCode == 200) {

        String code;
          if (response.data['data']['code']== null) {
            code = "";
          } else {
            code = response.data['data']['code'];
          }

          String denomination;
          if (response.data['data']['denomination']== null) {
            denomination = "";
          } else {
            denomination = response.data['data']['denomination'];
          }

          String description;
          if (response.data['data']['description']== null) {
            description = "";
          } else {
            description = response.data['data']['description'];
          }
          
          //images can be empty 
          String image;
          if (response.data['data']['images'].isEmpty) {
            image = "";
          } else {
            image = response.data['data']['images'][0];
          }

          //url can be null 
          String url;
          if (response.data['data']['url'] == null) {
            url = "";
          } else { url = response.data['data']['url']; }

          String initD;
          if (response.data['data']['initial_date'] == null) {
            initD = "";
          } else {
            initD = response.data['data']['initial_date'];
          }
          
          String finalD;
          if (response.data['data']['final_date'] == null) {
            finalD = "";
          } else {
            finalD = response.data['data']['final_date'];
          }

          String schedule;
          if (response.data['data']['schedule'] == null) {
            schedule = "";
          } else {
            schedule = response.data['data']['schedule'];
          }

          String city;
          if (response.data['data']['region'] == null || response.data['data']['region'].length < 3) {
              city = "";
          } else {
            city = response.data['data']['region'][2];
          }

          String adress;
          if (response.data['data']['address'] == null) {
            adress = "";
          } else {
            adress = response.data['data']['address'];
          }
          
          String tickets;
          if (response.data['data']['tickets'] == null) {
            tickets = "";
          } else {
            tickets = response.data['data']['tickets'];
          }

          List<dynamic> ambits = [];
          if(response.data['data'][i]['ambits'] != null) ambits.addAll(response.data['data'][i]['ambits']);

          String latitude;
          if (response.data['data']['latitude'] == null) {
            latitude = "";
          } else {
            latitude = response.data['data']['latitude'];
          }

          String longitude;
          if (response.data['data']['longitude'] == null) {
            longitude = "";
          } else {
            longitude = response.data['data']['longitude'];
          }
        
        Event event = Event(
            code,
            denomination,
            description,
            image,
            url,
            initD,
            finalD,
            schedule,
            city,
            adress,
            tickets,
            latitude,
            longitude,
            ambits,
        );
        return event;
      }
      else return emptyEvent;
    } catch (error) {
        return emptyEvent;
      }
  }

  void unsaveEvent(String codeEvent) async {
      
      try {
      //unsave event 
      final response = await dio.post('http://nattech.fib.upc.edu:40331/api/v1/users/unsaveEvent/$codeEvent');
  
      //cheking response
      print(response.statusCode);

    } catch (error) {
      print(error.toString());
    }
  }


  static Future<List<Event>> getEventsByAmbit(String ambit) async{
    try {
      List<Event> eventsByAmbit = [];
    
      final response = await dio.get('http://nattech.fib.upc.edu:40331/api/v1/events/searchByAmbit?ambit=$ambit');
      print(response.statusCode);
      if (response.statusCode == 200) {
        if(response.data['data'] != null) {
          for (int i = 0; i < response.data['data'].length; ++i) { //response is already decoded. 
        
          String denomination;
          if(response.data['data'][i]['denomination'] == null) {
            denomination = '';
          } else {denomination = response.data['data'][i]['denomination'];}

          String description;
          if (response.data['data'][i]['description'] == null) {description = '';}
          else {description = response.data['data'][i]['description']; }

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
          } else { url = response.data['data'][i]['url']; }

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

          String city;
          if (response.data['data'][i]['region'] == null || response.data['data'][i]['region'].length < 3) {
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

          List<dynamic> ambits = [];
          if(response.data['data'][i]['ambits'] != null) ambits.addAll(response.data['data'][i]['ambits']);

          Event event = Event(
            response.data['data'][i]['code'],
            denomination,
            description,
            image,
            url,
            initD,
            finalD,
            schedule,
            city,
            adress,
            tickets,
            latitude,
            longitude,
            ambits
          );
          eventsByAmbit.add(event);
          print(eventsByAmbit[i].title);
          }
          print(eventsByAmbit.length);
        return eventsByAmbit;
        }
      }
      return [];
    } catch (error){
      print(error.toString());
      return [];
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

  static Future<List<Event>> getEventsByDateRange(String initDate, String finalDate) async{
    try {
      List<Event> eventsByDataRange = [];
    
      final response = await dio.get('http://nattech.fib.upc.edu:40331/api/v1/events/search?initial_date=$initDate&final_date=$finalDate');
      print(response.statusCode);
      if (response.statusCode == 200) {
        if(response.data['data'] != null) {
          for (int i = 0; i < response.data['data'].length; ++i) { //response is already decoded. 
        
          String denomination;
          if(response.data['data'][i]['denomination'] == null) {
            denomination = '';
          } else {denomination = response.data['data'][i]['denomination'];}

          String description;
          if (response.data['data'][i]['description'] == null) {description = '';}
          else {description = response.data['data'][i]['description']; }

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
          } else { url = response.data['data'][i]['url']; }

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

          String city;
          if (response.data['data'][i]['region'] == null || response.data['data'][i]['region'].length < 3) {
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

          List<dynamic> ambits = [];
          if(response.data['data'][i]['ambits'] != null) ambits.addAll(response.data['data'][i]['ambits']);

          Event event = Event(
            response.data['data'][i]['code'],
            denomination,
            description,
            image,
            url,
            initD,
            finalD,
            schedule,
            city,
            adress,
            tickets,
            latitud,
            longitud,
            ambits
          );
          eventsByDataRange.add(event);
           }
          return eventsByDataRange;
        }
      }
      return [];
    } catch (error){
      print(error.toString());
      return [];
    }
  }
}