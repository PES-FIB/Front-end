import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import '../APIs/userApis.dart';
import '../models/User.dart';
import 'dioController.dart';
import '../APIs/userApis.dart';
//import 'package:shared_preferences/shared_preferences.dart';


import 'dart:async';

class userController{
  final BuildContext context;

  userController(this.context);

  static Future<int> signUp(String name, String email, String password) async {
    Response response;
    try {
    response  = await dio.post(userApis.getRegisterUrl(), 
    data: {
      'email': email,
      'name': name,
      'password': password,
    });
    }
    on DioError catch (e) {
      print(e.message);
      return -1;
    }
    await getUserInfo();
    return response.statusCode!;
  }
  
  static Future<int> logOut() async {
    Response response;
    try {
      response = await dio.get(userApis.getLogoutUrl());
    }
    on DioError catch (e) {
      print(e.message);
      return -1;
    }
    print(response.statusCode);
    return response.statusCode!;
  } 

  static Future<void> getUserInfo() async {
    Response response;
    try {
      response = await dio.get(userApis.getshowMe());
    }
    on DioError catch (e) {
      print(e.message);
      return;
    }
    print(response.data['user']);
    User.setValues(response.data['user']['id'], response.data['user']['name'], response.data['user']['email']);
  }

  static Future<void> updateUserInfo(String name, String email) async {
    try {
      await dio.patch(userApis.getupdateUser(),
      data: {
        'name': name,
        'email': email
      }
      );
    }
    on DioError catch (e) {
      print(e.message);
      throw Exception(e.message);
    } 
    User.setValues(User.id, name, email);

  }
}