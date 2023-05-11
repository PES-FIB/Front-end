import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'views/login_page.dart';
import 'dart:io';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import '../controllers/dioController.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async{
  Intl.defaultLocale = 'ca-ES';
  final cookieJar = CookieJar();
  dio.interceptors.add(CookieManager(cookieJar));

  HttpOverrides.global = MyHttpOverrides();

  initializeDateFormatting().then((_) => runApp(MyApp()));
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Culturica't",
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: LoginPage(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    HttpClient httpClient = super.createHttpClient(context);
    httpClient.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    return httpClient;
  }
}
