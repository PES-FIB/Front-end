import 'package:dio/dio.dart';

final dio = Dio(
  BaseOptions(
    connectTimeout: Duration(seconds: 20),
    //los unicos status validos son 200 y 302
    validateStatus: (status) => status == 200 || status == 302,
  ),
);