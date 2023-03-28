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

  Future<void> signUp(String name, String email, String password) async {
    final http.Response response = await
    http.post(
    Uri.parse(UserApis.getRegisterUrl()),
    body: jsonEncode(<String, String>{
      'name': name,
      'email': email,
      'password': password,
    }),
    );   
  }

}