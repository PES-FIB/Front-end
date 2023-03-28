import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import '../views/EventList.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';


class EventsController {
  final BuildContext context;
  EventsController(this.context);

  static Future<List<Event>> getAll() async {
    
    List<Event> allEvents = []; //initialize empty event list.

    try {

      Dio dio = Dio();
      CookieJar cookieJar = CookieJar();
      dio.interceptors.add(CookieManager(cookieJar));

      //login for accessing events.
      final authLogin = await dio.post('http://nattech.fib.upc.edu:40331/api/v1/auth/login', data: {'email':'cbum@gmail.com', 'password':'cbumpostman'});
      
      //checking login response
      print(authLogin.statusCode);

      //request events 
      final response = await dio.get('http://nattech.fib.upc.edu:40331/api/v1/events');
       
      //cheking events response
      print(response.statusCode);
  
      if (response.statusCode == 200) {
        print('OK');
       
        print('DECODED');
        for (int i = 0; i < response.data['data'].length; ++i) {
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
}