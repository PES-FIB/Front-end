import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:prova_login/models/AppEvents.dart';
import '../models/User.dart';
import '../models/Task.dart';
import '../APIs/taskApis.dart';
//import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';

class taskController {
  // ignore: non_constant_identifier_names
  static Future<void> getAllTasks() async {
    Response r;
    try {
      r = await dio.get('${taskApis.getTaskUrl()}/${User.id}');
    } catch (e) {
      print(e);
      return;
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
          repeats = repeatstoCat(repeats);
          Task t = Task(
              id, code, name, description, initialDate, finalDate, repeats);
          addTaskLocale(t);
        }
      }
    }
  }

  static String repeatstoCat(String repeats) {
    if (repeats == 'daily') {
      repeats = 'Diàriament';
    } else if (repeats == 'weekly') {
      repeats = 'Setmanalment';
    } else if (repeats == 'monthly') {
      repeats = 'Mensualment';
    } else if (repeats == 'yearly') {
      repeats = 'Anualment';
    } else {
      repeats = 'NO';
    }
    return repeats;
  }

  static String repeatstoEng(String repeats) {
    if (repeats == 'Diàriament') {
      repeats = 'daily';
    } else if (repeats == 'Setmanalment') {
      repeats = 'weekly';
    } else if (repeats == 'Mensualment') {
      repeats = 'monthly';
    } else if (repeats == 'Anualment') {
      repeats = 'yearly';
    } else {
      repeats = 'NO';
    }
    return repeats;
  }

  // ignore: non_constant_identifier_names
  static Future<int> createTask(String name, String description,
      String initial_date, String final_date, String? repeats) async {
    repeats = repeatstoEng(repeats!);
    print('valor repeats = $repeats');
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
        repeats = repeatstoCat(repeats);
        Task t =
            Task(id, code, name, description, initialDate, finalDate, repeats);
        addTaskLocale(t);
      }
      return 1;
    } else {
      return -1;
    }
  }

  static Future<List<Task>> get1Task(Task t) async {
    List<Task> ltask = [];
    Response r;
    try {
      r = await dio.get('${taskApis.getTaskUrl()}/${User.id}/${t.id}');
    } catch (e) {
      print(e);
      return [];
    }
    if (r.statusCode == 200) {
      if (r.data['data'] != null) {
        print ('r.data 1 tasca = ${r.data['data'].length}');
          String name = r.data['data']['name'];

          String description;
          if (r.data['data']['description'] != null) {
            description = r.data['data']['description'];
          } else {
            description = '';
          }

          String initialDate = r.data['data']['initial_date'];

          String finalDate = r.data['data']['final_date'];

          int id = r.data['data']['id'];

          int code = r.data['data']['code'];

          String repeats;
          if (r.data['data']['repeats'] != null) {
            repeats = r.data['data']['repeats'];
          } else {
            repeats = '';
          }
          repeats = repeatstoCat(repeats);
          Task t = Task(
              id, code, name, description, initialDate, finalDate, repeats);
          ltask.add(t);
      }
    }
    return ltask;
  }

  static Future<List<Task>> getTasks(Task t) async {
    List<Task> ltask = [];
    Response r;
    try {
      r = await dio.get('${taskApis.getTaskUrl()}/${User.id}/code/${t.code}');
    } catch (e) {
      print(e);
      return [];
    }
    if (r.statusCode == 200) {
      if (r.data['data'] != null) {
        print ('r.data todaaas = ${r.data['data'].length}');
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
          repeats = repeatstoCat(repeats);
          Task t = Task(
              id, code, name, description, initialDate, finalDate, repeats);
          ltask.add(t);
        }
      }
    }
    return ltask;
  }

  static Future<int> updateTask(
      Task oldTask,
      int Taskid,
      String name,
      String description,
      String initial_date,
      String final_date,
      String? repeats,
      bool cascade) async {
        repeats = repeatstoEng(repeats!);
    if (repeats == 'NO' || repeats == '') {
      repeats = null;
    }
    List<Task> oldList = [];
    if (cascade == true) {
      print('entro aqui porque edito en cascada');
      oldList = await getTasks(oldTask);
    }
    else {
      oldList = await get1Task(oldTask);
    }
     for (int j = 0; j < oldList.length; ++j) {
        deleteTaskLocale(oldList[j].id);
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
        "update_all_code": cascade.toString()
      });
    } catch (e) {
      return -1;
    }
    print('resultat tasca = ${r.statusCode}');
    if (r.statusCode == 200) {
      print('length update = ${r.data['data'].length}');
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
        repeats = repeatstoCat(repeats);
        Task t =
            Task(id, code, name, description, initialDate, finalDate, repeats);
        addTaskLocale(t);
      }
      return 1;
    } else {
      return -1;
    }
  }

  static Future<int> deleteTask(Task t2, bool cascade) async {
    print('cascade = $cascade');
    Response r;
    try {
      r = await dio.delete('${taskApis.getTaskUrl()}/${User.id}/${t2.id}',
          data: {"delete_all_code": cascade.toString()});
    } catch (e) {
      return -1;
    }
    print('status code del delete = ${r.statusCode}');
    if (r.statusCode == 200) {
      print('llargada de result de request = ${r.data['data'].length}');
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
        repeats = repeatstoCat(repeats);
        Task t =
            Task(id, code, name, description, initialDate, finalDate, repeats);
        print('son iguals les tasks? -> ${t == t2}');
        deleteTaskLocale(t.id);
      }
      return 1;
    } else {
      return -1;
    }
  }

  static void addTaskLocale(Task t) {
    int days = DateUtils.dateOnly(DateTime.parse(t.final_date))
        .difference(DateUtils.dateOnly(DateTime.parse(t.initial_date)))
        .inDays;
    for (int i = 0; i <= days; ++i) {
      if (AppEvents.tasksCalendar.containsKey(
          DateUtils.dateOnly(DateTime.parse(t.initial_date))
              .add(Duration(days: i)))) {
        AppEvents.tasksCalendar[
                DateUtils.dateOnly(DateTime.parse(t.initial_date))
                    .add(Duration(days: i))]
            ?.add(t);
      } else {
        List<Task> l = [];
        l.add(t);
        AppEvents.tasksCalendar[
            DateUtils.dateOnly(DateTime.parse(t.initial_date))
                .add(Duration(days: i))] = l;
      }
    }
  }

  static void deleteTaskLocale(int taskId) {
    print('entrodeleteee amb taskId = $taskId');
    // Search for the task with the given ID in the tasksCalendar map
    for (final tasks in AppEvents.tasksCalendar.values) {
      for (final task in tasks) {
        if (task.id == taskId) {
          int days = DateUtils.dateOnly(DateTime.parse(task.final_date))
              .difference(DateUtils.dateOnly(DateTime.parse(task.initial_date)))
              .inDays;
          print('dies = $days');
          print('tamany abans: ${tasks.length}');
          tasks.remove(task);
          for (int i = 0; i <= days; ++i) {
            AppEvents.tasksCalendar[
                    DateUtils.dateOnly(DateTime.parse(task.initial_date))
                        .add(Duration(days: i))]
                ?.remove(task);
          }
          print('tamany despres: ${tasks.length}');
          return; // Exit the function after deleting the task
        }
      }
    }
    // If the task is not found, print an error message
    print('Task with ID $taskId not found in tasksCalendar');
  }
}
