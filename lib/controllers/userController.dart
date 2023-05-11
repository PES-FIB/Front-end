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
      final error = e.message;
      print("Error: $error");
      return -1;
    }
    await getUserInfo();
    return response.statusCode!;
  }
  
  static Future<int> logOut() async {
    Response response;
    try {
      response = await dio.get(userApis.getLogoutUrl());
      print(response.data);
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
      final message = e.message;
      print('Error: $message');
      return;
    }
    print(response.data['user']);
    User.setValues(response.data['user']['id'], response.data['user']['name'], response.data['user']['email'], response.data['user']['image']);
  }

  static Future<bool> updateUserInfo(String name, String email) async {
    Response r;
      r = await dio.patch(userApis.getupdateUser(),
      data: {
        'name': name,
        'email': email
      },
      );
    if (r.statusCode != 200) {
      return false;
      
    }
    else {
    User.setValues(User.id, name, email, '');
    return true;
    }
  }

  static Future<bool> updateUserPassword(String oldPassword, String newPassword) async {
    Response r;
      r = await dio.patch(userApis.getupdatePassword(),
      data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword
      },
      );
      if (r.statusCode != 200) {
        return false;
      }
      return true;
  }

  static Future<bool> deleteUser(int id) async {
    return true;
  }
}