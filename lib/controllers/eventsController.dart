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
      print(authLogin.statusCode);

      //request events 
      final response = await dio.get('http://nattech.fib.upc.edu:40331/api/v1/events');
       
      //cheking events response
      print(response.statusCode);
  
      if (response.statusCode == 200) {
        for (int i = 0; i < response.data['data'].length; ++i) { //response is already decoded. 
        Event event = Event(
          response.data['data'][i]['denomination'],
          response.data['data'][i]['description'], false
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


  static Future<List<Event>> getSavedEvents() async {
    
    List<Event> savedEvents = []; //initialize empty event list.

    try {
      //login for accessing events.
      final authLogin = await dio.post('http://nattech.fib.upc.edu:40331/api/v1/auth/login', data: {'email':'cbum@gmail.com', 'password':'cbumpostman'});
      
      //checking login response
      print(authLogin.statusCode);

      //request current user saved events
      final response = await dio.get('http://nattech.fib.upc.edu:40331/api/v1/users/savedEvents');
       
      //cheking events response
      print(response.statusCode);
  
      if (response.statusCode == 200) {
        for (int i = 0; i < response.data['data'].length; ++i) { //response is already decoded. 
        Event event = Event(
          response.data['data'][i]['denomination'],
          response.data['data'][i]['description'], false
        );
        
        savedEvents.add(event);
        }
        return savedEvents;
      }
      return []; // return an empty list if there was an error
    } catch (error) {
      print(error.toString());
      return []; // return an empty list if there was an error
    }
  }


  void saveEvent(String codeEvent) async {
      
      try {
      //auth login for getting autorization
      final authLogin = await dio.post('http://nattech.fib.upc.edu:40331/api/v1/auth/login', data: {'email':'cbum@gmail.com', 'password':'cbumpostman'});
      
      //checking login response
      print(authLogin.statusCode);

      //save event 
      final response = await dio.post('http://nattech.fib.upc.edu:40331/api/v1/events/saveEvent/$codeEvent');
  
      //cheking response
      print(response.statusCode);

    } catch (error) {
      print(error.toString());
    }
  }

   void unsaveEvent(String codeEvent) async {
      
      try {
      //auth login for getting autorization
      final authLogin = await dio.post('http://nattech.fib.upc.edu:40331/api/v1/auth/login', data: {'email':'cbum@gmail.com', 'password':'cbumpostman'});
      
      //checking login response
      print(authLogin.statusCode);

      //unsave event 
      final response = await dio.post('http://nattech.fib.upc.edu:40331/api/v1/events/unsaveEvent/$codeEvent');
  
      //cheking response
      print(response.statusCode);

    } catch (error) {
      print(error.toString());
    }
  }

}