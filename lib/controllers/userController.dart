import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import '../APIs/userApis.dart';
//import 'package:shared_preferences/shared_preferences.dart';


import 'dart:async';

class userController{
  final BuildContext context;

  userController(this.context);

  static Future<int> signUp(String name, String email, String password) async {
    final dio = Dio();
    final cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));
    final response = await dio.post(userApis.getRegisterUrl(), 
    data: {
      'email': email,
      'name': name,
      'password': password,
    });
    print(response);
    return response.statusCode!;
  }
}