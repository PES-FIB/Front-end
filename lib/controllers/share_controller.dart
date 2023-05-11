// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

import 'package:share_plus/share_plus.dart';

class ShareController {  

  String ObtainMessage(String title, String url) {
    if (url == "") {
      final eventname = title;
      return ("Check out this event! $eventname, this event doesn't have a link.");
    }
    else {
      return ("Check out this event found on CulturiCAT!\n$url , you can find more information about this event in the link");
    }
    } 
      
  void ShareAction(String message) {
    Share.share(message);
  }

}