// ignore_for_file: non_constant_identifier_names

import 'dart:js';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../views/main_screen.dart';
import '../views/create_account_google.dart';
import '../views/create_account.dart';

import '../APIs/userApis.dart';

import 'dart:async';
import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';


class LoginPageController {
  final BuildContext context;

  LoginPageController(this.context);
  
  //needed for google login


  Future<int> loginUser(String email, String password) async {
    final http.Response response = await
    http.post(
      Uri.parse(UserApis.getLoginUrl()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
    ); 
    return response.statusCode;
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

  void to_signUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateAccount()),
    );
  }
  
/*
  void to_signUpGoogle(String email,String? username) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateAccountWithGoogle(username: username, email: email)),
    );
  }
 
 
  Future<void> googleLogin() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(clientId: "737004462925-1f4pjgoj7agb8c2310d3mu6o7d0epdck.apps.googleusercontent.com").signIn();
      if (googleUser != null) {
        final String email = googleUser.email;
        final String? username = googleUser.displayName;
        //verificamos si el usuario ya existe en la base de datos
        final response = await http.get(Uri.parse('http://localhost:8080/api/v1/apitest/users/$email'));
        if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
          //verificar si los datos coinciden
          realize_login();
        } 
        else {
          to_signUpGoogle(email, username);
        }
      }
    } catch (e) {
      print(e);
      print("Error");
    }
  }
  */
}
