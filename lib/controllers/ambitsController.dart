import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dioController.dart';

class AmbitsController {
  final BuildContext context;
  AmbitsController(this.context);

  static Future<List<String>> getAllAmbits() async {
    List<String> allAmbits = []; 
    try {
      //request events 
      final response = await dio.get('http://nattech.fib.upc.edu:40331/api/v1/ambits');
       
      if (response.statusCode == 200) {

        if(response.data['data'] != null) {
          for (int i = 0; i < response.data['data'].length; ++i) { //response is already decoded. 
            allAmbits.add(response.data['data'][i]['name']);
          }
          print(allAmbits[0]);
          return allAmbits;
        }
        return []; 
      }
      return [];// return an empty list if there was an error
    } catch (error) {
      print(error.toString());
      return []; // return an empty list if there was an error
    }
  }
}