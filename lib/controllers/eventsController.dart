import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';

import '../views/EventList.dart';
import 'dioController.dart';


class EventsController {
  final BuildContext context;
  EventsController(this.context);

  static Future<List<Event>> getAllEvents() async {
    
    List<Event> allEvents = []; //initialize empty event list.

    try {
      //login for accessing events.
      final authLogin = await dio.post('http://nattech.fib.upc.edu:40331/api/v1/auth/login', data: {'email':'cbum@gmail.com', 'password':'cbumpostman'});
      
      //checking login response
      //print(authLogin.statusCode);

      //request events 
      final response = await dio.get('http://nattech.fib.upc.edu:40331/api/v1/events');
       
      //cheking events response
      //print("no ha saltat error al demanar els events.");
      //print(response.statusCode);
  
      if (response.statusCode == 200) {
        for (int i = 0; i < response.data['data'].length; ++i) { //response is already decoded. 
        
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

        Event event = Event(
          response.data['data'][i]['code'],
          response.data['data'][i]['denomination'],
          response.data['data'][i]['description'],
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
        return allEvents;
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
      //login for accessing events.
      final authLogin = await dio.post('http://nattech.fib.upc.edu:40331/api/v1/auth/login', data: {'email':'cbum@gmail.com', 'password':'cbumpostman'});
      
      //checking login response
      //print(authLogin.statusCode);

      //request current user saved events
      final response = await dio.get('http://nattech.fib.upc.edu:40331/api/v1/users/savedEvents');
       
      //cheking events response
      print(response.statusCode);
  
      if (response.statusCode == 200) {
        for (int i = 0; i < response.data['data'].length; ++i) { //response is already decoded. 
        String image;
        if (response.data['data'][i]['images'].isEmpty) {
          image = "";
        } else {
          image = response.data['data'][i]['images'][0];
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

        String city;
        if (response.data['data'][i]['region'][2] == null) {
          city = "";
        } else {
          city = response.data['data'][i]['region'][2];
        }

        String adress;
        if (response.data['data'][i]['adress'] == null) {
          adress = "";
        } else {
          adress = response.data['data'][i]['adress'];
        }
        
        String tickets;
        if (response.data['data'][i]['tickets'] == null) {
          tickets = "";
        } else {
          tickets = response.data['data'][i]['tickets'];
        }

        Event event = Event(
          response.data['data'][i]['denomination'],
          response.data['data'][i]['description'],
          response.data['data'][i]['code'],
          image,
          response.data['data'][i]['url'],
          initD,
          finalD,
          schedule,
          city,
          adress,
          tickets
        );
        savedEvents[response.data['data'][i]['code']] = event;
        }
        return savedEvents;
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
  
      //cheking response
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

  static Future<String> existsSavedEvent (String codeEvent) async {
    try {
      //auth login for getting autorization
      final authLogin = await dio.post('http://nattech.fib.upc.edu:40331/api/v1/auth/login', data: {'email':'cbum@gmail.com', 'password':'cbumpostman'});
      //checking if event is saved
      final response = await dio.get('http://nattech.fib.upc.edu:40331/api/v1/users/existSavedEvent/$codeEvent');

      print("statusCode existsSavedEvent:"); print(response.statusCode);
      if (response.data['exists'] != null) {return response.data['exists'];}
      else {return "";}
  
    } catch (error) {
      print(error.toString());
      return "";
    }
    
  }
}