import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'views/login_page.dart';

void main() async{
  final cookieJar = CookieJar();
  dio.interceptors.add(CookieManager(cookieJar));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Culturica't",
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: LoginPage(),
    );
  }
}