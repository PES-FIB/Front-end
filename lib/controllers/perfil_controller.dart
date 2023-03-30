import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../APIs/users_apis.dart';

import 'dart:async';



class PerfilController {
  final BuildContext context;

  PerfilController(this.context);
  

  Future<int> logutUser() async {
    final http.Response response = await
    http.get(
      Uri.parse(UserApis.getLogoutUrl()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
    },
    ); 
    return response.statusCode;
  }
}