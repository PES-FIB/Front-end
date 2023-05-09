// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages

import 'package:flutter/material.dart';

import '../views/main_screen.dart';
import '../views/create_account.dart';

import '../APIs/userApis.dart';

import 'dart:async';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'dioController.dart';
import 'userController.dart';

//import 'package:google_sign_in/google_sign_in.dart';


class LoginPageController {
  final BuildContext context;

  LoginPageController(this.context);
  
  Future<int> loginUser(String email, String password) async {
    final response = await dio.post(userApis.getLoginUrl(),   
    data: {
      'email': email,
      'password': password,
    }
    ); 
    await userController.getUserInfo('');
    realize_login();
    return response.statusCode!;
  }

  Future<void> realize_login() async { 
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
