import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'dart:async';
import 'dart:convert';

import '../models/Event.dart';
import 'dioController.dart';


class EventsController {
  final BuildContext context;
  EventsController(this.context);

  static Future<List<Event>> getAllEvents() async {
    
    List<Event> allEvents = []; //initialize empty event list.

    try {

      //request events 
      final response = await dio.get('http://nattech.fib.upc.edu:40331/api/v1/events');
       
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
            ambits
          );
          allEvents.add(event);
          }
          return allEvents;
        }

        }
      return []; // return an empty list if there was an error
    } catch (error) {
      print(error.toString());
      return []; // return an empty list if there was an error
    }
  }


  static Future<Map<String, Event>> getSavedEvents() async {
    
    Map<String,Event> savedEvents = {}; //initialize empty event list.

    try {
      //request current user saved events
      final response = await dio.get('http://nattech.fib.upc.edu:40331/api/v1/users/savedEvents');
       
      //cheking events response
      print(response.statusCode);
  
      if (response.statusCode == 200) {
        if (response.data['events'] != null) {
          for (int i = 0; i < response.data['events'].length; ++i) { //response is already decoded. 

          String denomination;
          if(response.data['data'][i]['denomination'] == null) {
            denomination = '';
          } else {denomination = response.data['data'][i]['denomination'];}

          String description;
          if (response.data['data'][i]['description'] == null) {description = '';}
          else {description = response.data['data'][i]['description']; }

          String image;
          if (response.data['events'][i]['images'].isEmpty) {
            image = "";
          } else {
            image = response.data['events'][i]['images'][0];
          }

          String url;
          if (response.data['events'][i]['url'] == null) {
            url = "";
          } else { url = response.data['events'][i]['url']; }

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
          if (response.data['events'][i]['region'][2] == null) {
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

          List<dynamic> ambits = [];
          if(response.data['data'][i]['ambits'] != null) ambits.addAll(response.data['data'][i]['ambits']);

          Event event = Event(
            response.data['events'][i]['code'],
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
            ambits,
          );
          savedEvents[response.data['events'][i]['code']] = event;
          }
          return savedEvents;
        }
      }
        return savedEvents; // return an empty list if there was an error
        
    } catch (error) {
      print(error.toString());
      return savedEvents; // return an empty list if there was an error
    }
  }


  void saveEvent(String codeEvent) async {
      
      try {

      //save event 
      final response = await dio.post('http://nattech.fib.upc.edu:40331/api/v1/users/saveEvent/$codeEvent');
      print("SAVED");
      //checking response
      print(response.statusCode);

    } catch (error) {
      print(error.toString());
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
            ambits
          );
          eventsByDataRange.add(event);
           }
          print("EVENTS BY DATA RANGE LENGHT");
          print(eventsByDataRange.length);
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