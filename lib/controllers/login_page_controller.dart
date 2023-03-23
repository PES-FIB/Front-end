// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../views/main_screen.dart';
import '../views/create_account.dart';

import 'dart:async';
import 'dart:convert';


class LoginPageController {
  final BuildContext context;

  LoginPageController(this.context);

  Future<bool> checkUser(String email, String password) async {

    try {
      final response = await http.get(Uri.parse('http://localhost:8080/api/v1/apitest/users/$email'));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['password'] == password) {
          return true;
        } else {
          return false;
        }
      }
      return false;
    } catch (error) {
      print(error.toString());
      return false;
    }
  }

  Future<void> realize_login() async { 
    //cambiar IsLoggedIn a true
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);   

    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }

  void signUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateAccount()),
    );
  }
}
