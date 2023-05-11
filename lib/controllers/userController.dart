import 'dart:io';
import 'package:flutter/material.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prova_login/models/AppEvents.dart';
import '../models/User.dart';
import 'dioController.dart';
import '../APIs/userApis.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';

class userController {
  final BuildContext context;

  userController(this.context);

  static Future<int> signUp(String name, String email, String password) async {
    Response response;
    try {
      response = await dio.post(userApis.getRegisterUrl(), data: {
        'email': email,
        'name': name,
        'password': password,
      });
    } on DioError catch (e) {
      print(e.message);
      return -1;
    }
    await getUserInfo();
    return response.statusCode!;
  }

  static Future<int> logOut() async {
    Response response;
    try {
      response = await dio.get(userApis.getLogoutUrl());
    } on DioError catch (e) {
      print(e.message);
      return -1;
    }
    print(response.statusCode);
    AppEvents.eventsList = [];
    AppEvents.savedEvents = {};
    AppEvents.savedEventsCalendar = {};
    AppEvents.tasksCalendar = {};
    return response.statusCode!;
  }

  static Future<void> getUserInfo() async {
    Response response;
    try {
      response = await dio.get(userApis.getshowMe());
    } on DioError catch (e) {
      print(e.message);
      return;
    }
    print(response.data['user']);
    User.setValues(response.data['user']['id'], response.data['user']['name'],
        response.data['user']['email']);
  }

  static Future<bool> updateUserInfo(String name, String email) async {
    Response r;
    r = await dio.patch(
      userApis.getupdateUser(),
      data: {'name': name, 'email': email},
    );
    if (r.statusCode != 200) {
      return false;
    } else {
      User.setValues(User.id, name, email);
      return true;
    }
  }

  static Future<bool> checkStoragePermission() async {
    PermissionStatus status = await Permission.storage.status;
    print('permission status = $status');
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      print('entrodenied');
      return await requestStoragePermission();
    } else {
      return false;
    }
  }

  static Future<bool> requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.request();
    print('entroo4235235');
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  static Future<int> exportCalendar(String fileName) async {
  bool hasPermission = await checkStoragePermission();
  if (!hasPermission) {
    return -2;
  }
  try {
    final directory = Directory("/storage/emulated/0/Download");
    print('el directori es = $directory');
    final file = File('${directory.path}/$fileName');
    dio.options.headers['Content-Type'] = 'application/octet-stream';
    dio.options.responseType = ResponseType.bytes;
    Response response = await dio.get(userApis.getExportCalendar());
    file.writeAsBytesSync(response.data);
  } catch (e) {
    print(e);
    return -1;
  }
  return 1;
}

  static Future<bool> updateUserPassword(
      String oldPassword, String newPassword) async {
    Response r;
    r = await dio.patch(
      userApis.getupdatePassword(),
      data: {'oldPassword': oldPassword, 'newPassword': newPassword},
    );
    if (r.statusCode != 200) {
      return false;
    }
    return true;
  }

  static Future<bool> deleteUser(int id) async {
    return true;
  }
}
