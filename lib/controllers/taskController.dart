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
import '../models/Task.dart';
import 'dioController.dart';
import '../APIs/userApis.dart';
import '../APIs/taskApis.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';

class taskController {
  // ignore: non_constant_identifier_names
  static Future<Map<DateTime, List<Task>>> getAllTasks() async {
    Map<DateTime, List<Task>> tasks = {};
    Response r;
    try {
      r = await dio.get('${taskApis.getTaskUrl()}/${User.id}');
    } catch (e) {
      print(e);
      return tasks;
    }
    if (r.statusCode == 200) {
      if (r.data['data'] != null) {
        for (int i = 0; i < r.data['data'].length; ++i) {
          String name = r.data['data'][i]['name'];

          String description;
          if (r.data['data'][i]['description'] != null) {
            description = r.data['data'][i]['description'];
          } else {
            description = '';
          }

          String initialDate = r.data['data'][i]['initial_date'];

          String finalDate = r.data['data'][i]['final_date'];

          int id = r.data['data'][i]['id'];

          int code = r.data['data'][i]['code'];

          String repeats;
          if (r.data['data'][i]['repeats'] != null) {
            repeats = r.data['data'][i]['repeats'];
          } else {
            repeats = '';
          }
          Task t = Task(id, code, name, description, initialDate, finalDate,repeats);
          int days = DateUtils.dateOnly(DateTime.parse(finalDate)).difference(DateUtils.dateOnly(DateTime.parse(initialDate))).inDays;
          for (int i = 0; i <= days; ++i) {
              if(tasks.containsKey(DateUtils.dateOnly(DateTime.parse(initialDate)).add(Duration(days: i)))){
                tasks[DateUtils.dateOnly(DateTime.parse(initialDate)).add(Duration(days: i))]?.add(t);
              }
              else {
                List<Task> l = [];
                l.add(t);
                tasks[DateUtils.dateOnly(DateTime.parse(initialDate)).add(Duration(days: i))] = l;
              }
            }
        }
      }
    }
    return tasks;
  }

  // ignore: non_constant_identifier_names
  static Future<int> createTask(String name, String description,
    String initial_date, String final_date, String? repeats) async {
    if (repeats == 'NO') {
      repeats = null;
    }
    Response r;
    try {
      r = await dio.post(taskApis.getTaskUrl(), data: {
        "name": name,
        "description": description,
        "initial_d": initial_date.substring(0, initial_date.indexOf(' ')),
        "initial_h": initial_date.substring(
            initial_date.lastIndexOf(' ') + 1, initial_date.length),
        "final_d": final_date.substring(0, final_date.indexOf(' ')),
        "final_h": final_date.substring(
            final_date.lastIndexOf(' ') + 1, final_date.length),
        "repeats": repeats,
        "user_id": User.id
      });
    } catch (e) {
      return -1;
    }
    print('resultat tasca = ${r.statusCode}');
    if (r.statusCode == 200) {
      String description;
      if (r.data['data']['description'] != null) {
        description = r.data['data']['description'];
      } else {
        description = '';
      }

      String repeats;
      if (r.data['data']['repeats'] != null) {
        repeats = r.data['data']['repeats'];
      } else {
        repeats = '';
      }
      Task t = Task(
          r.data['data']['id'],
          r.data['data']['code'],
          r.data['data']['name'],
          description,
          r.data['data']['initial_date'],
          r.data['data']['final_date'],
          repeats);
      addTaskLocale(t);
      return 1;
    }
    else {
      return -1;
    }
  }

  static Future<int> updateTask(Task oldTask, int Taskid, String name, String description, String initial_date, String final_date, String? repeats)  async{
    if (repeats == 'NO' || repeats == '') {
      repeats = null;
    }
    Response r;
    try {
      r = await dio.put('${taskApis.getTaskUrl()}/${User.id}/$Taskid', data: {
        "name": name,
        "description": description,
        "initial_d": initial_date.substring(0, initial_date.indexOf(' ')),
        "initial_h": initial_date.substring(
            initial_date.lastIndexOf(' ') + 1, initial_date.length),
        "final_d": final_date.substring(0, final_date.indexOf(' ')),
        "final_h": final_date.substring(
            final_date.lastIndexOf(' ') + 1, final_date.length),
        "repeats": repeats,
        "update_all_code": "true"
      });
    } catch (e) {
      return -1;
    }
    print('resultat tasca = ${r.statusCode}');
    if (r.statusCode == 200) {
      String description;
      if (r.data['data']['description'] != null) {
        description = r.data['data']['description'];
      } else {
        description = '';
      }

      String repeats;
      if (r.data['data']['repeats'] != null) {
        repeats = r.data['data']['repeats'];
      } else {
        repeats = '';
      }
      Task t = Task(
          r.data['data']['id'],
          r.data['data']['code'],
          r.data['data']['name'],
          description,
          r.data['data']['initial_date'],
          r.data['data']['final_date'],
          repeats);
      updateTaskLocale(oldTask,t);
      return 1;
    }
    else {
      return -1;
    }
  }

  static void updateTaskLocale(Task oldt, Task t) {
    print('old = ${oldt.description} and new = ${t.description}');
    //delete all instances of the old task
    int days = DateUtils.dateOnly(DateTime.parse(oldt.final_date)).difference(DateUtils.dateOnly(DateTime.parse(oldt.initial_date))).inDays;
    for (int i = 0; i <= days; ++i) {
        AppEvents.tasksCalendar[DateUtils.dateOnly(DateTime.parse(oldt.initial_date)).add(Duration(days: i))]?.remove(oldt);
    }
    //add all instances of new task
    int days2 = DateUtils.dateOnly(DateTime.parse(t.final_date)).difference(DateUtils.dateOnly(DateTime.parse(t.initial_date))).inDays;
    for (int i = 0; i <= days2; ++i) {
      if(AppEvents.tasksCalendar.containsKey(DateUtils.dateOnly(DateTime.parse(t.initial_date)).add(Duration(days: i)))){
        AppEvents.tasksCalendar[DateUtils.dateOnly(DateTime.parse(t.initial_date)).add(Duration(days: i))]?.add(t);
      }
      else {
        List<Task> l = [];
        l.add(t);
        AppEvents.tasksCalendar[DateUtils.dateOnly(DateTime.parse(t.initial_date)).add(Duration(days: i))] = l;
      }
    }
  }

  static void addTaskLocale(Task t) {
    int days = DateUtils.dateOnly(DateTime.parse(t.final_date)).difference(DateUtils.dateOnly(DateTime.parse(t.initial_date))).inDays;
    for (int i = 0; i <= days; ++i) {
      if(AppEvents.tasksCalendar.containsKey(DateUtils.dateOnly(DateTime.parse(t.initial_date)).add(Duration(days: i)))){
        AppEvents.tasksCalendar[DateUtils.dateOnly(DateTime.parse(t.initial_date)).add(Duration(days: i))]?.add(t);
      }
      else {
        List<Task> l = [];
        l.add(t);
        AppEvents.tasksCalendar[DateUtils.dateOnly(DateTime.parse(t.initial_date)).add(Duration(days: i))] = l;
      }
    }
  }

  static void deleteTask(Task t) {}

  static void deleteTaskLocale(Task t) {
    AppEvents.tasksCalendar[DateUtils.dateOnly(DateTime.parse(t.initial_date))]
        ?.remove(t);
  }
}
