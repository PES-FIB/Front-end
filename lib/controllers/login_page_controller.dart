// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages, unnecessary_null_comparison, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';

import '../models/User.dart';
import '../views/main_screen.dart';
import '../views/create_account.dart';

import '../APIs/userApis.dart';

import '../views/styles/custom_snackbar.dart';

import 'dart:async';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'dioController.dart';
import 'userController.dart';

import 'package:webview_flutter/webview_flutter.dart';


class LoginPageController {
  final BuildContext context;

  LoginPageController(this.context);
  
  Future<int?> loginUser(String email, String password) async {
    Response response;
    try{
      response = await dio.post(userApis.getLoginUrl(),   
        data: {
          'email': email,
          'password': password,
        }
      ); 
      await userController.getUserInfo('');
      realize_login();
      return response.statusCode!;
    } on DioError catch (error){
      print(error);
      return error.response?.statusCode;
    } 
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
  

 
  Future<void> googleLogin() async {
    String finalUrl = "";

    final redirect = await dio.post(
      userApis.getSignInGoogle(),
    );
    String initialUrl = '';
    //si la llamada es una redireccion
    if (redirect.statusCode == 302) {
      initialUrl = redirect.headers.value(HttpHeaders.locationHeader)!;
    }
    if (initialUrl != null && initialUrl != '') {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => WebView(
            initialUrl: initialUrl,
            javascriptMode: JavascriptMode.unrestricted,
            userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36 OPR/80.0.4170.16 (Edition beta) JavaScriptEnabled',
            onPageStarted: (String url) async {
              if (url.startsWith(userApis.getSignInGoogleCollback())) {
                finalUrl = url;
                if(Navigator.canPop(context)) Navigator.pop(context); 
              }
            },
          ),
        ),
      );
      try {
        final response = await dio.get(
          finalUrl,
          options: Options (
            validateStatus: (_) => true,
            contentType: Headers.jsonContentType,
            responseType:ResponseType.json,
          ),
        );
        print(response.data);
        print(response.statusCode);
        //logejar a l'usuari dins de l'aplicació
        //print(response.data['picture']);
        await userController.getUserInfo(response.data['picture']);
        //missatge de success
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackbar( context, 'Login de Google realizado correctamente')
        );
        realize_login();
      } catch (e){
        print('Error al hacer la llamada a la API: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackbar( context, 'Se ha producido un error: $e')
        );
      }

    }
  }
}
