// ignore_for_file: camel_case_types

// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../controllers/eventsController.dart';
import '../models/AppEvents.dart';
import '../models/User.dart';
import '../APIs/userApis.dart';
import 'package:permission_handler/permission_handler.dart';
import '../controllers/taskController.dart';
import '../views/main_screen.dart';
import '../views/create_account.dart';
import '../views/styles/custom_snackbar.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
class UserController {
  final BuildContext context;

  UserController(this.context);

  static Future<int> signUp(String name, String email, String password) async {
    Response response;
    try {
      response = await dio.post(userApis.getRegisterUrl(), data: {
        'email': email,
        'name': name,
        'password': password,
      });
    } on DioError {
      return -1;
    }
    AppEvents.eventsList = await EventsController.getAllEvents();
    AppEvents.mapEvents = await EventsController.getMapEvents();
    AppEvents.ambits = await EventsController.getAllAmbits();
    AppEvents.savedChanged = false;
    print("AMBITS FETCHED");
    getUserInfo();
    return response.statusCode!;
  }

  static Future<int> logOut() async {
    Response response;
    try {
      response = await dio.get(userApis.getLogoutUrl());
    } on DioError {
      return -1;
    }
    AppEvents.eventsList = [];
    AppEvents.savedEvents = {};
    AppEvents.savedEventsCalendar = {};
    AppEvents.tasksCalendar = {};
    clearCookie();
    return response.statusCode!;
  }

  static Future<void> getUserInfo() async {
    Response response;
    try {
      response = await dio.get(userApis.getshowMe());
    } on DioError {
      return;
    }
    String? photoUrl = '';
    if (response.data['user']['image'] != null) {
      if (response.data['user']['image'].toString().startsWith('https://')) {
        photoUrl = response.data['user']['image'];
      } else {
        photoUrl = 'http://nattech.fib.upc.edu:40331${response.data['user']['image']}';
      }
    }
    User.setValues(response.data['user']['id'], response.data['user']['name'],
        response.data['user']['email'], photoUrl);
    print("User: ${User.name} ${User.email} ${User.photoUrl}");
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
      User.setValues(User.id, name, email, User.photoUrl);
      return true;
    }
  }


  Future<bool> pickImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    Response response;
    print(pickedImage!.path);
    print(pickedImage.name);
    
    if (pickedImage != null) {
      try {
        FormData formData = FormData.fromMap(
          {
            'profileImage': await MultipartFile.fromFile(pickedImage.path, contentType: MediaType('image', 'png')), // Ajusta el tipo de contenido según el formato de imagen),
          }
        );
        print(formData.files.first.value.filename);
        response = await dio.put(
          userApis.uploadImage(),
          data: formData,
        );
        
        if (response.statusCode == 200) {
          Response user = await dio.get(userApis.getshowMe());
          final photoUrl = 'http://nattech.fib.upc.edu:40331${user.data['user']['image']}';
          User.setValues(User.id, User.name, User.email, photoUrl);
          return true;
        } else {
          return false;
        }
      } catch (e) {
        if (e is DioError) {
          if (e.response != null) {
            print(e.response?.data);
          }
        } else {
          print(e);
        }
        return false;
      }
    }
    return false;
  }

  static Future<bool> checkStoragePermission() async {
    PermissionStatus status = await Permission.storage.status;
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      return await requestStoragePermission();
    } else {
      return false;
    }
  }

  static Future<bool> requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.request();
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
    final file = File('${directory.path}/$fileName');
    dio.options.headers['Content-Type'] = 'application/octet-stream';
    dio.options.responseType = ResponseType.bytes;
    Response response = await dio.get(userApis.getExportCalendar());
    file.writeAsBytesSync(response.data);
  } catch (e) {
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
    Response r;
    try {
      r = await dio.delete(userApis.getDeleteUser());
    }
    catch (e) {
      return false;
    }
    if (r.statusCode == 200) {
      AppEvents.eventsList =  [];
      AppEvents.savedEvents = {};
      AppEvents.savedEventsCalendar = {};
      AppEvents.tasksCalendar = {};
      return true;
    }
    else {
      return false;
    }
  }

  static Future<int> loginUser(String email, String password) async {
    final response = await dio.post(userApis.getLoginUrl(),   
    data: {
      'email': email,
      'password': password,
    }
    ); 
    if(response.statusCode == 400 && response.data['msg'] == 'You have been blocked!') {
      return -1;
    } else if (response.statusCode == 200){
      String? rawCookie = response.headers['set-cookie']![0];
      String? cookie = rawCookie.split(';')[0];
      print("Cookie: $cookie");
      await manageCookie(cookie);
      await UserController.getUserInfo();
    }
    print(response.statusCode!);
    return response.statusCode!;
  }

  static Future<void> realize_login(context) async { 
    try {
      AppEvents.eventsList = await EventsController.getAllEvents();
      AppEvents.mapEvents = await EventsController.getMapEvents();
      AppEvents.ambits = await EventsController.getAllAmbits();
      AppEvents.savedChanged = false;

      // ignore: prefer_interpolation_to_compose_strings
      await EventsController.getSavedEvents();
      await taskController.getAllTasks();
    } catch (e) {
      return;
    }
    finally {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
    }
  }

  static void to_signUp(context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateAccount()),
    );
    }

    
   static Future<bool> googleLogin(context) async {
    String finalUrl = "";

    final redirect = await dio.post(
      userApis.getSignInGoogle(),
    );
    String initialUrl = '';
    //si la llamada es una redireccion
    if (redirect.statusCode == 302) {
      initialUrl = redirect.headers.value(HttpHeaders.locationHeader)!;
    }
    if (initialUrl != '') {
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
        String? rawCookie = response.headers['set-cookie']![0];
        String? cookie = rawCookie.split(';')[0];
        print("Cookie: $cookie");
        await manageCookie(cookie);
        //logejar a l'usuari dins de l'aplicació
        await UserController.getUserInfo();
        //missatge de success
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackbar( context, 'Login de Google realitzat correctament')
        );
        return true;
      } on DioError catch (e){
        if (e.response!.data['msg'] == 'You have been blocked!') {
          // ignore: use_build_context_synchronously
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                alignment: Alignment.center,
                content: Text('Usuari bloquejat per l\'administració del sistema!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.redAccent), textAlign: TextAlign.center,),
              );
            },
          );
        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackbar( context, 'S\'ha produit algun error: $e')
          );
        }
        return false;
      }
    }
    return false;
  }

  static Future<void> manageCookie(String? cookie) async {
    if (cookie != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print('prefs initialized');
      prefs.setString('Cookie', cookie);
      dio.options.headers['Cookie'] = cookie;
      print("cookie saved");
    }
  }
  static Future<void> clearCookie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('Cookie');
    dio.options.headers['Cookie'] = null;
  }

  Future<bool> initPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cookie = prefs.getString('Cookie');
    print('Cookie: $cookie');
    if (cookie != null) {
      dio.options.headers['Cookie'] = cookie;
      print("cookie loaded");
      await getUserInfo();
      if(User.id != -1) {
        realize_login(context);
        return true;
      }
      return false;
    }
    print('prefs initialized');
    return false;
  }
}
