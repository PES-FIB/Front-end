import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../APIs/userApis.dart';
//import 'package:shared_preferences/shared_preferences.dart';

import '../main_screen.dart';


import 'dart:async';

class CreateAccountController {
  final BuildContext context;

  CreateAccountController(this.context);

  Future<int> signUp(String name, String email, String password) async {
    final http.Response response = await
    http.post(
    Uri.parse(UserApis.getRegisterUrl()),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'name': name,
      'password': password,
    }),
    ); 
    return response.statusCode;
  }
}