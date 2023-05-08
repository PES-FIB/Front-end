import 'dart:io';
import 'dart:js_util';
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
import '../models/Task.dart';
import 'dioController.dart';
import '../APIs/userApis.dart';
import '../APIs/taskApis.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';

class taskController {
  static void /*Future<Map<DateTime,List<Task>>>*/ getAllTasks() {
    Map<DateTime, List<Task>> m = {};
    return null;
  }

  // ignore: non_constant_identifier_names
  static Future<int> createTask(String name, String description, String initial_date, String final_date, String repeats) async {
    Response r;
    try {
      r = await dio.post(taskApis.getTaskUrl(), data: {
        "name": name,
        "description": description,
        "initial_d": initial_date.substring(0, initial_date.indexOf(' ')),
        "initial_h": initial_date.substring(initial_date.lastIndexOf(' ')+ 1, initial_date.length),
        "final_d":  final_date.substring(0, final_date.indexOf(' ')),
        "final_h": final_date.substring(final_date.lastIndexOf(' ')+ 1, final_date.length),
        "repeats": repeats,
        "user_id": User.id
      });
    } catch (e) {
      return -1;
    }
    return 1;
  }

  static void addTaskLocale(Task t) {
    if (AppEvents.tasksCalendar.containsKey(DateUtils.dateOnly(DateTime.parse(t.initial_date)))) {
    AppEvents.tasksCalendar[DateUtils.dateOnly(DateTime.parse(t.initial_date))]?.add(t);
    }
    else {
      List<Task> l = [t];
       AppEvents.tasksCalendar[DateUtils.dateOnly(DateTime.parse(t.initial_date))] = l;
    }
  }

  static void deleteTask(Task t) {}

  static void deleteTaskLocale(Task t) {
    AppEvents.tasksCalendar[DateUtils.dateOnly(DateTime.parse(t.initial_date))]?.remove(t);
  }
}
