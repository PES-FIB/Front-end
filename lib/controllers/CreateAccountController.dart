import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:shared_preferences/shared_preferences.dart';

import '../main_screen.dart';


import 'dart:async';
import 'dart:convert';

class CreateAccountController {
  final BuildContext context;

  CreateAccountController(this.context);

  Future<void> signUp(String name, String email, String password) async {
    //await http.put(Uri.parse('http://localhost:8080/api/v1/apitest/users'));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }

}